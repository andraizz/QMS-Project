part of 'installation_bloc.dart';

abstract class InstallationEvent {}

class FetchInstallationTypes extends InstallationEvent {}

class FetchInstallationSteps extends InstallationEvent {
  final int installationTypeId;

  FetchInstallationSteps(this.installationTypeId);
}
