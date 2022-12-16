import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'click_state.dart';

class ClickCubit extends Cubit<ClickState> {
  ClickCubit() : super(ClickInitial());

  var count = 0;
  var data = "";

  void onClick(Brightness br) {
    if (br == Brightness.light)
    {
      count++;
      data = '+1; тема: светлая';
    }
    else
    {
      count += 2;
      data = '+2; тема: темная';
    }
    if (count >= 10) {
      emit(ClickError('Счетчик достиг ' + count.toString()));
      count = 0;
      return;
    }

    emit(Click(count,data));
  }

  void onClickMinus(Brightness br) {
    if (br == Brightness.light)
    {
      count--;
      data = '-1; тема: светлая';

    }
    else
    {
      count -= 2;
      data = '-2; тема: темная';
    }
    if (count <= -10) {
      emit(ClickError('Счетчик достиг ' + count.toString()));
      count = 0;
      return;
    }

    emit(Click(count, data));
  }
}


@immutable
abstract class ListViewState {}

class ListViewInitial extends ListViewState {}

class ListViewCubit extends Cubit<List<String>> {
  ListViewCubit() : super([]);

final List<String > list = [];

  void add(String count){
    /*if (list.length == 20)
      list.clear();*/
    list.insert(0,count);
    emit([...list]);
  }

}