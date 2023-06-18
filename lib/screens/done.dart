import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/state.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit , AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var tasks = cubit.doneTasks;
        return Scaffold(
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
                        child: IconButton(
                            onPressed: ()
                            {
                              cubit.updateDatabase(
                                status: "archived",
                                id: tasks[index]['id'],
                              );
                            },
                            icon:const Icon(Icons.archive_outlined, color: Colors.grey)),
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) =>const SizedBox(height: 0,),
                  itemCount: tasks.length);
            },
            fallback: (context) => const Center(child: Text('No tasks yet')),),
        );
      },

    );
  }
}
