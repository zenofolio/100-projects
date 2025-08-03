import 'package:flutter/material.dart';
import 'package:remo/application/modules/connect/adapters/device_adapter.dart';
import 'package:remo/application/ui/shared/components/animate.dart';

class DevicesList extends StatelessWidget {

  final List<DeviceAdapter> list;
  final void Function(DeviceAdapter) onPress;
  const DevicesList({ super.key, required this.list, required this.onPress });


  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);

     return Padding(
       padding: EdgeInsets.all(20),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         spacing: 20,
         children: [
           Text("Select a device to connect", style: theme.textTheme.titleLarge),
           Column(
             spacing: 10,
             mainAxisAlignment: MainAxisAlignment.center,
             children: List.generate(list.length, (index){

               var item = list[index];


               return AnimateFrom(
                 direction: AnimateDirection.bottom,
                 delay: Duration( milliseconds:  100 * index),
                 child: ListTile(
                   tileColor: theme.cardColor,
                   leading: CircleAvatar(
                     child: Icon(Icons.tv),
                   ),
                   title:  Text(item.name),
                   subtitle: Text(item.brand),
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(12)
                   ),
                   trailing: Icon(Icons.arrow_forward_rounded),
                   onTap: () => onPress(item),
                 ),
               );

             }),
           )
         ],
       ),
     );
  }
}