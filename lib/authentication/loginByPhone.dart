import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class loginByPhonePage extends StatefulWidget {
  const loginByPhonePage({super.key});

  @override
  State<loginByPhonePage> createState() => _loginByPhonePageState();
}

class _loginByPhonePageState extends State<loginByPhonePage> {

  var key=GlobalKey<FormState>();
  var namecontroller=TextEditingController();
  var phonecontroller=TextEditingController();
  var emailcontroller=TextEditingController();
  var passwordcontroller=TextEditingController();
  var done=true;
  var locationdone=false;

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
              Image(image: AssetImage('assets/images/signuplogo.png'),height: size*0.2,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Get On Board!",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 30),),
                    SizedBox(width: 10,),
                    done?SpinKitDualRing(size: 20,
                      color: Colors.black,):SpinKitThreeInOut(
                      size: 30,
                      color: Colors.black,
                    ),
                  ]),
              SizedBox(height: 4,),
              Text("Fill the below form to start your journey!",style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 15),textAlign: TextAlign.start,),
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
                          controller: emailcontroller,
                          validator: (value){
                            if(value!.isEmpty || !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value.trim())){
                              return "Enter Correct email";
                            }
                            else return null;
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.alternate_email_outlined,color: Colors.grey,),
                              labelText: "E-mail",
                              labelStyle: TextStyle(color: Colors.grey),
                              hintText: "E-mail",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                              )
                          ),
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
                        SizedBox(height: 10,),
                        TextFormField(
                          obscureText: true,
                          controller: passwordcontroller,
                          validator: (value){
                            value=value!.trim();
                            if(value!.isEmpty || value!.length<6){
                              return "Password length must be atleast 6.";
                            }
                            else return null;
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.fingerprint,color: Colors.grey,),
                              suffixIcon: Icon(Icons.remove_red_eye,color: Colors.grey,),
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.grey),
                              hintText: "Password",
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
                                 // Fluttertoast.showToast(msg: "Formatting Error");
                                }
                                else {
                                  //Fluttertoast.showToast(msg: "Processing...");
                                //  createuserwithemailandpass(emailcontroller.text, passwordcontroller.text);
                                }
                              },
                              child: Text(done?"Processing...":"Sign-Up",style:TextStyle(color: Colors.white),),
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
                        SizedBox(height: 15,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Or",style:TextStyle(color: Colors.black),),
                            SizedBox(height: 10,),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: (){},
                                label: Text("Sign-in with Google"),
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(),
                                    foregroundColor: Colors.black,
                                    side: BorderSide(color: Colors.black),
                                    padding: EdgeInsets.symmetric(vertical: 14)
                                ), icon: Image(image: AssetImage('assets/images/googlelogo.png'),width: 20,),
                              ),
                            )
                          ],
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
