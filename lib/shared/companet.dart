

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


Widget textButton({
  required Function() onPress,
  required String text,
}){
  return TextButton(onPressed:onPress , child: Text(text,
  style: const TextStyle(
      color: Colors.blue,
      fontSize: 18),));
}
 navigatorAndRemove({
  required BuildContext context,
   required Widget widget,
}){
   Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>widget), (route) => false);
}

navigatorPush({
  required BuildContext context,
  required Widget widget,
}){
  Navigator.push(context,MaterialPageRoute(builder: (context)=>widget),);
}

Widget mainButton({
  required Function() fct,
  required String text,
  required double height,
}){
  return MaterialButton(
    onPressed: fct,
    minWidth: double.infinity,
    color: Colors.blue,
    textColor: Colors.white,
    height: height,
    child:   Text(text,style: const TextStyle(
        fontSize: 20
    ),),
  );
}

PreferredSizeWidget mainAppBar({
  required String name,
  required BuildContext context,
   List<Widget>? action,
}){
  return AppBar(
    backgroundColor: Colors.white,
    foregroundColor: Colors.grey.shade900,
    title: Text(name,
        style: TextStyle(
            color: Colors.grey.shade900,
            fontWeight: FontWeight.bold,
            fontSize: 20
        )),
    leading:
      InkWell(
        onTap: ()=>Navigator.of(context).pop(),
        child: const Icon(Icons.arrow_back_ios,),
    ),
    elevation: 0.0,
    actions: action,
  );
}

Widget useTextButton({
  required String name,
  required Function() onPress,

}){
  return TextButton(onPressed: onPress,
      child: Text(name.toUpperCase(),style:const TextStyle(fontSize: 16)));

}

Widget defaultTextFiled({
  required TextEditingController controller,
  required TextInputType inputType,
  required String labelText,
  required IconData prefixIcon,
  required FormFieldValidator<String> validator,
  ValueChanged<String>? onFieldSubmitted,
  IconData? suffixIcon,
  int? maxLines,
  Function()? fctSuffixIcon,
  bool? obscureText,
}){
  return  TextFormField(
    keyboardType:inputType ,
    obscureText: obscureText??false,
    controller: controller,
    maxLines: maxLines??1,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: labelText,
      prefixIcon: Icon(prefixIcon),
      suffixIcon: IconButton(
        onPressed: fctSuffixIcon,
        icon: Icon(suffixIcon),
      ),
      contentPadding:const  EdgeInsets.all(20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(color: Colors.blue,width: 5),
      ),
    ),
    validator: validator,
    onFieldSubmitted: onFieldSubmitted,

  );
}

 showToast({
  required String msg,
   required Color color,

})async{
  return  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 18.0,
  );
}

showDialogImages({required BuildContext context, required Function() camera, required Function() gallery,}){
  showDialog(context: context,
      builder: (context){
        return AlertDialog(
          title:const  Text(
            'Please choose an option',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: camera,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Icon(Icons.photo,color: Colors.blue,),
                      SizedBox(width: 10,),
                      Text('Camera',
                        style: TextStyle(
                            color: Colors.blue,fontSize: 20
                        ),)
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: gallery,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Icon(Icons.camera,color: Colors.blue,),
                      SizedBox(width: 10,),
                      Text('Gallery',
                        style: TextStyle(
                            color: Colors.blue,fontSize: 20
                        ),)
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      });
}