
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:symptoms/bloc/app_cubit.dart';
import 'package:symptoms/bloc/app_state.dart';
import 'package:symptoms/screen/auth/loginscreen.dart';
import 'package:symptoms/shared/companet.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  var formKey=GlobalKey<FormState>();
  var nameController=TextEditingController();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var phoneController=TextEditingController();

  String ? type;
  List<String> typeList=['Doctor','Student'];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
      listener: (context,state){
        if(state is SuccessSignUpState){
          navigatorAndRemove(context: context,widget: LoginScreen());
        }
        else if (state is ErrorSignUpState){
          showToast(color: Colors.red,msg: 'Check in information');
        }
      },
      builder: (context,state){
        var cubit = AppCubit.get(context);
        return Scaffold(
            body:Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sign Up',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.black
                          ),),
                        const SizedBox(height: 15,),
                        Text('Sign Up now with Friends',
                            style: Theme.of(context).textTheme.headline5),
                        const SizedBox(height: 25,),
                        Center(
                          child: SizedBox(
                            width: 85,
                            height: 85,
                            child: Stack(
                              children: [
                                Container(
                                  width:80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey
                                      )
                                  ),
                                  child:

                                  cubit.image==null?
                                  Center(
                                    child: Icon(Icons.image_aspect_ratio_rounded,size: 30),
                                  )
                                      : Image.file(cubit.image!,fit: BoxFit.fill,
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: ()async{
                                      XFile? picked=await ImagePicker().pickImage(source: ImageSource.gallery,maxHeight: 1080,maxWidth: 1080);
                                      if(picked !=null){
                                        cubit.changeImage(img: File(picked.path));
                                      }
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration:BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child:Center(
                                        child:Icon(cubit.image == null ? Icons.add : Icons.edit,color:Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),


                        const SizedBox(height: 15,),
                        defaultTextFiled(
                          controller: nameController,
                          inputType: TextInputType.text,
                          labelText: 'Name',
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please Enter The Name';
                            }
                          },
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(height: 15,),
                        defaultTextFiled(
                          controller: emailController,
                          inputType: TextInputType.emailAddress,
                          labelText: 'Email Address',
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please Enter The Email';
                            }
                          },
                          prefixIcon: Icons.email,
                        ),
                        const SizedBox(height: 15,),
                        defaultTextFiled(
                          controller: passwordController,
                          inputType: TextInputType.visiblePassword,
                          labelText: 'Password',
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please Password is Shorted';
                            }
                          },
                          prefixIcon: Icons.lock,
                          suffixIcon: cubit.obscureText?Icons.visibility:Icons.visibility_off,
                            fctSuffixIcon: ()=>cubit.visiblePassword(),
                          obscureText: cubit.obscureText
                        ),
                        const SizedBox(height: 15,),
                        defaultTextFiled(
                          controller: phoneController,
                          inputType: TextInputType.phone,
                          labelText: 'Phone Number',
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please Enter The Phone';
                            }
                          },
                          prefixIcon: Icons.phone,
                        ),
                        const SizedBox(height: 15,),
                        DropdownButtonFormField(
                          hint: const Text('Type'),
                          items: [
                            ...typeList.map((e){
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              );
                            })
                          ],
                          value: type,
                          onChanged: (val){
                            type =val;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(color: Colors.blue,width: 5),
                            ),
                          ),
                          validator: (val){
                            if(val==null){
                              return 'Please Enter The Type';

                            }
                          },
                        ),
                        const SizedBox(height: 15,),

                        const SizedBox(height: 25,),
                        (state is! LoadingSignUpState)?
                        MaterialButton(
                          onPressed: (){
                            if(formKey.currentState!.validate()){
                             if(cubit.image!=null){
                               cubit.signUp(
                                 type: type!,
                                 email: emailController.text,
                                 password: passwordController.text,
                                 name: nameController.text,
                                 phone: phoneController.text,);
                             }else{
                               showToast(color: Colors.red,msg: 'Check in Select Image');
                             }
                            }
                            },
                          minWidth: double.infinity,
                          color: Colors.blue,
                          textColor: Colors.white,
                          height: 50,
                          child:  const Text('Create Account',style: TextStyle(
                              fontSize: 20
                          ),),
                        ):
                        const Center(child:CircularProgressIndicator()),
                        const SizedBox(height: 15,),
                        Row(
                          children: [
                            const Text('Do have a account?',
                              style: TextStyle(fontSize: 16
                              ),),
                            useTextButton(name: 'Login',
                                onPress: ()=>Navigator.pop(context))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
        );
      },
    );
  }
}
