import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_mobile_app/pages/welcome/bloc/welcomeEvent.dart';
import 'package:project_mobile_app/pages/welcome/bloc/welcomeState.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(WelcomeState()) {
    on<WelcomeEvent>((event, emit) {
      emit(WelcomeState(page: state.page));
    });
  }
}
