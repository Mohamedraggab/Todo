import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/state.dart';
import 'package:intl/intl.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var scaffoldKey = GlobalKey<ScaffoldState>();
        var titleController = TextEditingController();
        var dateController = TextEditingController();
        var timeController = TextEditingController();
        var tasks = cubit.listOfTasks ;
        var formKey = GlobalKey<FormState>();
        return Scaffold(
          key: scaffoldKey,
          body: ConditionalBuilder(
              condition: tasks.isNotEmpty,
              builder: (context) {
                return ListView.separated(
                    itemBuilder: (context, index) => Dismissible(
                      key: Key(tasks[index]['id'].toString()),
                      onDismissed: (direction) {
                        cubit.deleteDatabase(id: (tasks[index]['id']));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepOrangeAccent,
                            radius: 30,
                            child: Text(tasks[index]['time'] ,
                              style:const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), softWrap: true,) ),
                        title: Text(tasks[index]['title']),
                        subtitle: Text(tasks[index]['date']),
                        trailing: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: ()
                                    {
                                      cubit.updateDatabase(
                                          status: "done",
                                          id: tasks[index]['id'],
                                      );
                                    },
                                    icon:const Icon(Icons.done , color: Colors.deepOrangeAccent,)),
                                IconButton(
                                    onPressed: ()
                                    {
                                      cubit.updateDatabase(
                                        status: "archived",
                                        id: tasks[index]['id'],
                                      );
                                    },
                                  icon:const Icon(Icons.archive_outlined, color: Colors.grey)),
                          ]),
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) =>const SizedBox(height: 0,),
                    itemCount: tasks.length);
              },
              fallback: (context) => const Center(child: Text('No tasks yet')),),


          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.deepOrangeAccent,
              elevation: 0.0,
              onPressed: (){
                if(cubit.sheetShow)
                {
                  if(formKey.currentState!.validate())
                  {
                    cubit.insertIntoDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    ).then((value){
                      cubit.sheetShow = false;
                    });

                  }
                  }
                else{
                  scaffoldKey.currentState!.showBottomSheet((context)
                  {
                    return Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                            children: [
                          const SizedBox(height: 35,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: (value) {
                                if(value!.isEmpty) {
                                  return 'Empty Filed';
                                }
                                return null ;
                              },
                                controller: titleController,
                                decoration: const InputDecoration(label: Text('Title'),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))) ,prefixIcon: Icon(Icons.title) )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                validator: (value) {
                                  if(value!.isEmpty) {
                                    return 'Empty Filed';
                                  }
                                  return null ;
                                },
                              onTap: () {
                                showDatePicker(context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2030))
                                    .then((value){

                                      dateController.text = DateFormat.yMMMd().format(value!);
                                });
                              },
                                controller: dateController,
                                keyboardType: TextInputType.none,
                                decoration: const InputDecoration(label: Text('Date'),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)))  ,prefixIcon: Icon(Icons.calendar_today) )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                validator: (value) {
                                  if(value!.isEmpty) {
                                    return 'Empty Filed';
                                  }
                                  return null ;
                                },

                                controller: timeController,
                                keyboardType: TextInputType.none,
                                onTap: () {
                                  showTimePicker(context: context,
                                      initialTime: TimeOfDay.now()
                                  ).then((value){
                                    timeController.text = value!.format(context).toString();
                                  }).catchError((error){});
                                },
                                decoration: const InputDecoration(label: Text('Time'),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)))  , prefixIcon: Icon(Icons.watch_later_outlined) )),
                          ),
                        ]),
                      ),
                    );
                  }).closed.then((value)
                  {
                    cubit.sheetShow = false;
                  });
                  cubit.sheetShow = true ;
                }

              } ,
              child: const Icon(Icons.edit,color: Colors.white,)),
        );
      },
    );
  }
}
