import 'package:adadeh_store/data/models/user_model.dart';
import 'package:adadeh_store/data/repositories/profile_repository.dart';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository = ProfileRepository();

  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileLoaded>((event, emit) async {
      emit(ProfileLoading());

      final profile = await _profileRepository.getUserProfile();

      emit(ProfileLoadedSuccess(profile: profile!));
    });
  }
}
