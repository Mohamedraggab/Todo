import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/state.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit , AppState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: cubit.titles[cubit.cIndex],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: cubit.screens[cubit.cIndex],
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0.0,
              currentIndex: cubit.cIndex,
              onTap: (value) {
                cubit.changeIndex(value);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu) , label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.done) , label: 'Done'),
                BottomNavigationBarItem(icon: Icon(Icons.archive_outlined) , label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }
}
