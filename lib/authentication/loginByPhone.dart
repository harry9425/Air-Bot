import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';
import 'package:untitled/modelClasses/userclass.dart';
import 'package:untitled/utils/colors.dart';

class loginByPhonePage extends StatefulWidget {
  const loginByPhonePage({super.key});

  @override
  State<loginByPhonePage> createState() => _loginByPhonePageState();
}

class _loginByPhonePageState extends State<loginByPhonePage> {

  var key=GlobalKey<FormState>();
  var namecontroller=TextEditingController();
  var phonecontroller=TextEditingController();
  var done=true;

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Image(image: AssetImage('assets/images/signuplogo.png'),height: size*0.2,),
              SizedBox(height: 10,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Get On Board!",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 30),),
                    SizedBox(width: 11,),
                    SpinKitFadingFour(
                      size: 30,
                      color: Colors.black,
                    ),
                  ]),
              SizedBox(height: 4,),
              Text("enter the following details.",style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 15),textAlign: TextAlign.start,),
              Form(
                  key: key,
                  child:Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.account_circle,color: Colors.grey,),
                              labelText: "Name",
                              labelStyle: TextStyle(color: Colors.grey),
                              hintText: "Name",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                              )
                          ),
                          validator: (value){
                            value=value!.trim();
                            if(value!.isEmpty || value!.length>20){
                              return "Enter Correct Name";
                            }
                            else return null;
                          },
                          controller: namecontroller,
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: phonecontroller,
                          validator: (value){
                            if(value!.isEmpty || !RegExp(r'([0-9]{10}$)').hasMatch(value.trim())){
                              return "Enter correct phone number format";
                            }
                            else return null;
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone_android,color: Colors.grey,),
                              labelText: "Phone",
                              labelStyle: TextStyle(color: Colors.grey),
                              hintText: "Phone",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                              )
                          ),
                        ),
                        SizedBox(height: 20,),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (){
                                  if(!(key.currentState!.validate())){
                                    Toast.show("Enter details correctly");
                                  }
                                  else {
                                    UserModel user=UserModel.empty();
                                  user.name=namecontroller.text.toString().trim().toLowerCase();
                                  user.phone=phonecontroller.text.toString().trim();
                                  Navigator.pushNamed(context,"verifyByPhone",arguments:user);
                                }
                              },
                              child: Text("Continue",style:TextStyle(color: Colors.white),),
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(),
                                  foregroundColor: Colors.white,
                                  side: BorderSide(color: Colors.black
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 14)
                              ),
                            )
                        ),
                        SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                              onPressed: ()=>{},
                              style: ElevatedButton.styleFrom(foregroundColor: Colors.grey),
                              child: Text("Already have an Account? Login",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),)
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
