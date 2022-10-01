import 'package:farmapp/provider/farm_note_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FarmNoteForm extends StatefulWidget {
  final index;
  const FarmNoteForm({this.index});

  @override
  _FarmNoteFormState createState() => _FarmNoteFormState();
}

class _FarmNoteFormState extends State<FarmNoteForm> {

  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();
 
 var provider;

  @override
  void initState(){
    super.initState();
 provider = Provider.of<FarmNoteProvider>(context, listen: false);
 initFarmData();
  if(this.widget.index != null) _editValues();
 
  }

  void initFarmData() async{
    await provider.getAllFarmNotes();
    
  }

    @override
  void dispose(){
    
     titleController.dispose();
     messageController.dispose();
   
    
    super.dispose();
    
  }

  
   _editValues() {

      titleController.text = provider.farmNoteList[this.widget.index].title;
      messageController.text = provider.farmNoteList[this.widget.index].message;
   }

  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("Add Note"),
        actions: [
          IconButton(
              onPressed: () async{

                var response = await provider.saveFarmNote(
                  titleController.text, messageController.text, updateId: this.widget.index != null ? provider.farmNoteList[this.widget.index].id : null

                );
                if(response){
                  await provider.getAllFarmNotes();
                  Navigator.pop(context);
                  

                }else{
                  print("failed");

                }


                
                // var milkProvider = Provider.of<MilkProvider>(context, listen: false);
                //  if (validateAndSave()) {

                //    _saveMilk();
                //    await milkProvider.getAllMilkRecord();
                   
                //    Navigator.pop(context);

                //  }


               
              
              },
              icon: Icon(
                Icons.gpp_good,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.title, color: Colors.black54),
                  SizedBox(width: 20,),
                  Expanded(
                    child: TextFormField(
                      controller: titleController,
                       cursorColor: Colors.orange,
                       autofocus: true,
                       decoration: InputDecoration(
              //labelText: "Search",
            
              hintText: "Title",
              border: InputBorder.none,

              hintStyle: TextStyle(
                color: Colors.black54
              ),
               

                  ),
                      
                      
                    ),
                  )
                ],
              ),

              SizedBox(height: 20,),

               Row(
                children: [
                  Icon(Icons.message, color: Colors.black54),
                  SizedBox(width: 20,),
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                       cursorColor: Colors.orange,
                       decoration: InputDecoration(
              //labelText: "Search",
            
              hintText: "Meassage",
              border: InputBorder.none,

              hintStyle: TextStyle(
                color: Colors.black54
              ),
               

                  ),
                      maxLines: null,
                      
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      
    );
  }
}