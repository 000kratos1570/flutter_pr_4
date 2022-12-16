import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lesson_4/cubit/click_cubit.dart';

void main() {
  runApp(const MyApp());
}

class SetTheme extends Cubit<ThemeData> {
  SetTheme() : super(ThemeData.light());

  void changeTheme() {
    if (state == ThemeData.light()) {
      emit(ThemeData.dark());
    } else {
      emit(ThemeData.light());
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SetTheme()),
        BlocProvider(
          create: (context) => ClickCubit(),
        ),
        BlocProvider(create: (context) => ListViewCubit()),
      ],
      child: BlocBuilder<SetTheme, ThemeData>(builder: (context, state) {
        return MaterialApp(
          theme: state,
          home: const MyHomePage(),
        );
      }),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<ClickCubit, ClickState>(
              builder: (context, state) {
                if (state is ClickError) {
                  return Text(state.message);
                }
                if (state is Click) {
                  return Text(state.Count.toString());
                }
                return const Text(
                  'Куда я жмал?',
                );
              },
            ),
            BlocBuilder<ListViewCubit, List<String>>(
              builder: (context, state) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(30, 30, 30, 120),
                    child: ListView.builder(
                      itemCount: state.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Text(
                            state[index],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(69, 0, 0, 40),
            child: FloatingActionButton(
              onPressed: () {
                context.read<SetTheme>().changeTheme();
              },
              tooltip: 'Theme',
              child: const Icon(Icons.star_half),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 20, 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  child: FloatingActionButton(
                    onPressed: () {
                      context
                          .read<ClickCubit>()
                          .onClick(Theme.of(context).brightness);
                      context
                          .read<ListViewCubit>()
                          .add(context.read<ClickCubit>().data.toString());
                    },
                    tooltip: 'Increment',
                    child: const Icon(Icons.add),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: FloatingActionButton(
                    onPressed: () {
                      context
                          .read<ClickCubit>()
                          .onClickMinus(Theme.of(context).brightness);
                      context
                          .read<ListViewCubit>()
                          .add(context.read<ClickCubit>().data.toString());
                    },
                    tooltip: 'Decrement',
                    child: const Icon(Icons.remove),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
