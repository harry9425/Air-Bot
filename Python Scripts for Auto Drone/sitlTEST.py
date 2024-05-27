from dronekit import connect, VehicleMode, LocationGlobal, LocationGlobalRelative
from pymavlink import mavutil 
import time
import math
import socket
import argparse
import geopy.distance
import numpy as np
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db

#dronekit-sitl copter --home=18.455047966603537,73.84792673313233,0,180
#mavproxy.py --master tcp:127.0.0.1:5760 --sitl 127.0.0.1:5501 --out 127.0.0.1:14550 --out 127.0.0.1:14551 --map

'''config = {
  apiKey: "AIzaSyDflPwafzipN0Pxh_WuGh-h1RTbfWCjz4U",
  authDomain: "airbotfinal.firebaseapp.com",
  databaseURL: "https://airbotfinal-default-rtdb.firebaseio.com",
  projectId: "airbotfinal",
  storageBucket: "airbotfinal.appspot.com",
  messagingSenderId: "193651702264",
  appId: "1:193651702264:web:82326dc48828cf9a6efe0d",
  measurementId: "G-TH4XVYSC8F"
};
'''

cred = credentials.Certificate("C:\\Users\\Harry\Desktop\\airbot\\airbotfinal-firebase-adminsdk-4nblq-bc29896bed.json")

try:
    firebase_admin.initialize_app(cred,{"databaseURL":"https://airbotfinal-default-rtdb.firebaseio.com"})
    print("Firebase Admin SDK initialized successfully!")
except ValueError as e:
    print("Error initializing Firebase Admin SDK:", str(e))
db_ref= db.reference("/")
ob =db_ref.child("drone/drone1/").get()
print("Drone 1 node check :")
print(ob)
parser = argparse.ArgumentParser()
parser.add_argument('--connect', default='127.0.0.1:14550')
args = parser.parse_args()

# Connect to the Vehicle
print('Connecting to vehicle on: %s' % args.connect)
vehicle = connect(args.connect, baud=921600, wait_ready=True)

#update Drone status online
print("Drone 1 ready to start")
db_ref.child("drone/drone1/currstatus").set(1)
db_ref.child("drone/drone1/battery").set(str(vehicle.battery.level))
ini_lat = vehicle.location.global_relative_frame.lat
ini_lon = vehicle.location.global_relative_frame.lon
ini_data = {
'latitude': ini_lat,
'longitude': ini_lon
}
db_ref.child("drone/drone1/homelocation").update(ini_data)
db_ref.child("drone/drone1").child("currentlocation").set(ini_data)

def get_params():
  # vehicle is an instance of the Vehicle class
  print("Autopilot Firmware version: %s" % vehicle.version)
  print("Autopilot capabilities (supports ftp): %s" % vehicle.capabilities.ftp)
  print("Global Location: %s" % vehicle.location.global_frame)
  print("Global Location (relative altitude): %s" % vehicle.location.global_relative_frame)
  print("Local Location: %s" % vehicle.location.local_frame)  # NED
  print("Attitude: %s" % vehicle.attitude)
  print("Velocity: %s" % vehicle.velocity)
  print("GPS: %s" % vehicle.gps_0)
  print("Groundspeed: %s" % vehicle.groundspeed)
  print("Airspeed: %s" % vehicle.airspeed)
  print("Gimbal status: %s" % vehicle.gimbal)
  print("Battery: %s" % vehicle.battery)
  print("EKF OK?: %s" % vehicle.ekf_ok)
  print("Last Heartbeat: %s" % vehicle.last_heartbeat)
  print("Rangefinder: %s" % vehicle.rangefinder)
  print("Rangefinder distance: %s" % vehicle.rangefinder.distance)
  print("Rangefinder voltage: %s" % vehicle.rangefinder.voltage)
  print("Heading: %s" % vehicle.heading)
  print("Is Armable?: %s" % vehicle.is_armable)
  print("System status: %s" % vehicle.system_status.state)
  print("Mode: %s" % vehicle.mode.name)  # settable
  print("Armed: %s" % vehicle.armed)  # settable


def get_distance(cord1, cord2):
    #return distance n meter
    return (geopy.distance.geodesic(cord1, cord2).km)*1000

def arm_and_takeoff(aTargetAltitude):

  print("Basic pre-arm checks")
  # Don't let the user try to arm until the autopilot is ready
  while not vehicle.is_armable:
    print("Waiting for vehicle to initialize...")
    time.sleep(1)
        
  print("Arming motors")
  # Copter should arm in GUIDED mode
  vehicle.mode = VehicleMode("GUIDED")
  vehicle.armed = True

  while not vehicle.armed:
    vehicle.armed = True
    print("Waiting for arming...")
    time.sleep(1)

  print("Taking off!")
  vehicle.simple_takeoff(aTargetAltitude) # Take off to target altitude

  # Check that the vehicle has reached takeoff altitude
  while True:
    print("Altitude: ", vehicle.location.global_relative_frame.alt) 
    # Break and return from function just below the target altitude.        
    if vehicle.location.global_relative_frame.alt >= aTargetAltitude * 0.95: 
      print("Reached target altitude")
      break
    time.sleep(1)

def goto_location(to_lat, to_long,speed):    
        
    print(" Global Location (relative altitude): %s" % vehicle.location.global_relative_frame)
    curr_lat = vehicle.location.global_relative_frame.lat
    curr_lon = vehicle.location.global_relative_frame.lon
    curr_alt = vehicle.location.global_relative_frame.alt

    # set to locaton (lat, lon, alt)
    to_lat = to_lat
    to_lon = to_long
    to_alt = curr_alt

    to_pont = LocationGlobalRelative(to_lat,to_lon,to_alt)
    vehicle.simple_goto(to_pont, groundspeed=speed)
    
    to_cord = (to_lat, to_lon)
    while True:
        curr_lat = vehicle.location.global_relative_frame.lat
        curr_lon = vehicle.location.global_relative_frame.lon
        curr_data = {
        'latitude': curr_lat,
        'longitude': curr_lon
        }
        db_ref.child("drone/drone1/currentlocation").update(curr_data)
        curr_cord = (curr_lat, curr_lon)
        print("curr location: {}".format(curr_cord))
        distance = get_distance(curr_cord, to_cord)
        print("distance ramaining {}".format(distance))
        if distance <= 30:
            db_ref.child("drone/drone1/missionStatus").set("Near your Location")
            print("Reached within 2 meters of target location...")
        if distance <= 2:
            db_ref.child("drone/drone1/missionStatus").set("Reached Location")
            print("Reached within 2 meters of target location...")
            break
        time.sleep(2)

def setIdle():
   callby=str(db_ref.child("drone/drone1/callBy").get())
   db_ref.child("Users").child(callby).child("BookingStatus").set(False)
   db_ref.child("Users").child(callby).child("BookedDrone").set("none")
   db_ref.child("drone/drone1/callBy").set("none")
   db_ref.child("drone/drone1/missionStatus").set("Idle")
   db_ref.child("drone/drone1/currstatus").set(0)
   db_ref.child("drone/drone1/currentlocation").delete()
   curr_lat = vehicle.location.global_relative_frame.lat
   curr_lon = vehicle.location.global_relative_frame.lon
   new_data = {
    'latitude': curr_lat,
    'longitude': curr_lon
   }
   db_ref.child("drone/drone1/homelocation").update(new_data)
   

def my_mission():
    
    currstatus=str(db_ref.child("drone/drone1/currstatus").get())
    while(currstatus=="1"):
       print("Drone at IDLE waiting for any call")
       time.sleep(1)
       currstatus=str(db_ref.child("drone/drone1/currstatus").get())

    callby=str(db_ref.child("drone/drone1/callBy").get())
    if(callby=="none"):
       print("error 506: node mismatch")
       return
    
    firstcheck =str(db_ref.child("Users").child(callby).child("BookingStatus").get())
    print(firstcheck)
    if(firstcheck!="True"):
       print("error 507: first check mismatch")
       return
    
    secondcheck =str(db_ref.child("Users").child(callby).child("BookedDrone").get())
    if(secondcheck!="drone1"):
       print("error 508: Second check mismatch")
       return
    
    username=str(db_ref.child("Users").child(callby).child("name").get())
    print(f"All Checks Done..\n Getting {username} home location..")

    coor_data =db_ref.child("Users").child(callby).child("coor").get()
    if coor_data:
        address = coor_data.get('address', '')
        latitude = coor_data.get('latitude', '')
        longitude = coor_data.get('longitude', '')
        db_ref.child("drone/drone1/missionStatus").set("Assigned")
        print("Ready to start mission")
        print(f"Target location is {address} and coordinates are {latitude} and {longitude}")
        time.sleep(5)

        print("starting mission")
        db_ref.child("drone/drone1/missionStatus").set("Taking Off")
        arm_and_takeoff(3)

        print(f"starting goto sequence towards {address}")

        time.sleep(5)
        db_ref.child("drone/drone1/missionStatus").set("On The Way")
        goto_location(latitude, longitude,4)

        print("hovering for 10 seconds you can drop the parcel or etc u want")
        time.sleep(10)

        db_ref.child("drone/drone1/missionStatus").set("Returning to base...")
        print("Returning to home position")
        vehicle.mode = VehicleMode("RTL")
        setIdle()
        
    else:
       print(f"error 509: Can't get {username} lcoation")
       return

my_mission()

print("Mission completed!! HURRAYYY")

vehicle.close()
