import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/cubit/state.dart';
import 'package:todo/screens/archived.dart';
import 'package:todo/screens/done.dart';

import '../screens/new_tasks.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(InitState());

  static AppCubit get(context) => BlocProvider.of(context);


  List<Map> listOfTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  int cIndex = 0;

  changeIndex(index) {
    cIndex = index;
    emit(ChangeIndexState());
  }


  var screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  var titles = const [
    Text('New Tasks'),
    Text('Done Tasks'),
    Text('Archived Tasks'),
  ];


  Database? database ;
  createDatabase() async
  {
     database = await openDatabase(
      'task.db',
      version: 1,
      onCreate: (database, version){
        database
            .execute('CREATE TABLE task(id INTEGER PRIMARY KEY , title TEXT ,date TEXT , time TEXT , status TEXT )')
            .then((value){
              print('table created');
        })
            .catchError((error){
              print('error is $error');
            });
      },
      onOpen: (database) {
        getDatabase(database)
            .then((value)
        {
          for (var element in value) {
            if(element['status'] == 'new')
            {
              listOfTasks.add(element);
            }
            if(element['status'] == 'done')
            {
              doneTasks.add(element);
            }
            if(element['status'] == 'archived')
            {
              archivedTasks.add(element);
            }
          }
          print(listOfTasks);
          print(doneTasks);
          print(archivedTasks);
          emit(GetDatabaseState());
        }
        );
        print('database opened');
      },
    );
  }


  Future<void> insertIntoDatabase({
    required String title,
    required String date,
    required String time,
})async
  {
    return await database!.transaction((txn)async
    {
      try{
        await txn.rawInsert(
            'INSERT INTO task( title , date , time , status ) VALUES ("$title" , "$date" , "$time" , "new")'
        );
        emit(InsertIntoDatabaseState());
        print('record added');
        getDatabase(database).then((value){
          listOfTasks = [] ;
          doneTasks = [] ;
          archivedTasks = [] ;
          for (var element in value) {
            if(element['status'] == 'new')
            {
              listOfTasks.add(element);
            }
            if(element['status'] == 'done')
            {
              doneTasks.add(element);
            }
            if(element['status'] == 'archived')
            {
              archivedTasks.add(element);
            }
          }
          emit(GetDatabaseState());
        });
      }catch(error)
      {
        print(error);
      }
    });

  }


  var sheetShow = false ;


  Future<List<Map>>getDatabase(database)async
  {
    return await database.rawQuery('SELECT * FROM task');

  }

  
  
  updateDatabase({
    required String status ,
    required int id ,
})async
  {
    await database!.rawUpdate('UPDATE task SET status = ? WHERE id = ? ' , [status , id])
        .then((value){
      getDatabase(database)
          .then((value)
      {
        listOfTasks = [] ;
        doneTasks = [] ;
        archivedTasks = [] ;
        for (var element in value) {
          if(element['status'] == 'new')
          {
            listOfTasks.add(element);
          }
          if(element['status'] == 'done')
          {
            doneTasks.add(element);
          }
          if(element['status'] == 'archived')
          {
            archivedTasks.add(element);
          }
        }
        emit(GetDatabaseState());
      }
      );
          emit(UpdateDatabaseState());
    });
  }




  deleteDatabase({
    required int id ,
  })async
  {
    await database!.rawDelete('DELETE FROM task WHERE id = ? ' , [id])
        .then((value){
      getDatabase(database)
          .then((value)
      {
        listOfTasks = [] ;
        doneTasks = [] ;
        archivedTasks = [] ;
        for (var element in value) {
          if(element['status'] == 'new')
          {
            listOfTasks.add(element);
          }
          if(element['status'] == 'done')
          {
            doneTasks.add(element);
          }
          if(element['status'] == 'archived')
          {
            archivedTasks.add(element);
          }
        }
        emit(GetDatabaseState());
      }
      );
      emit(DeleteDatabaseState());
    });
  }


  
}