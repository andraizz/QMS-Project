import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qms_application/data/models/models.dart';
import 'package:qms_application/data/source/sources.dart';

part 'installation_event.dart';
part 'installation_state.dart';

class InstallationBloc extends Bloc<InstallationEvent, InstallationState> {
  final InstallationSource installationSource;

  InstallationBloc(this.installationSource) : super(InstallationInitial()) {
    // Register event handlers
    on<FetchInstallationTypes>((event, emit) async {
      await _mapFetchInstallationTypesToState(emit);
    });

    on<FetchInstallationSteps>((event, emit) async {
      await _mapFetchInstallationStepsToState(emit, event.installationTypeId);
    });
  }

  Future<void> _mapFetchInstallationTypesToState(Emitter<InstallationState> emit) async {
    emit(InstallationTypesLoading(state));
    try {
      final installationTypes = await installationSource.listInstallationTypes();
      if (installationTypes != null) {
        emit(InstallationTypesLoaded(installationTypes));
      } else {
        emit(InstallationError('Failed to load installation types'));
      }
    } catch (e) {
      emit(InstallationError(e.toString()));
    }
  }

  Future<void> _mapFetchInstallationStepsToState(Emitter<InstallationState> emit, int installationTypeId) async {
    emit(InstallationStepsLoading(state));
    try {
      final installationSteps = await installationSource.listInstallationSteps(installationTypeId);
      if (installationSteps != null) {
        emit(InstallationStepsLoaded(installationSteps));
      } else {
        emit(InstallationError('Failed to load installation steps'));
      }
    } catch (e) {
      emit(InstallationError(e.toString()));
    }
  }
}

