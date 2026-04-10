// lib/features/address/presentation/binding/address_binding.dart

import 'package:get/get.dart';
import 'package:userapp/core/network/api_service.dart';
import 'package:userapp/features/profile/presentation/screen/address/data/datasources/address_remote_datasource.dart';
import 'package:userapp/features/profile/presentation/screen/address/data/repositories/address_repository_impl.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/repositories/address_repository.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/usecases/create_address_usecase.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/usecases/delete_address_usecase.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/usecases/get_addresses_usecase.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/usecases/update_address_usecase.dart';
import 'package:userapp/features/profile/presentation/screen/address/presentation/address_controller.dart';
import 'package:userapp/utils/services/location_service.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    // Register ApiService if not already registered
    if (!Get.isRegistered<ApiService>()) {
      Get.put<ApiService>(ApiService());
    }

    // Register AddressRemoteDataSource with proper type
    if (!Get.isRegistered<AddressRemoteDataSource>()) {
      Get.put<AddressRemoteDataSource>(AddressRemoteDataSourceImpl());
    }

    // Register AddressRepository
    if (!Get.isRegistered<AddressRepository>()) {
      Get.put<AddressRepository>(
        AddressRepositoryImpl(dataSource: Get.find<AddressRemoteDataSource>()),
      );
    }

    // Register UseCases
    if (!Get.isRegistered<GetAddressesUseCase>()) {
      Get.put<GetAddressesUseCase>(
        GetAddressesUseCase(Get.find<AddressRepository>()),
      );
    }

    if (!Get.isRegistered<CreateAddressUseCase>()) {
      Get.put<CreateAddressUseCase>(
        CreateAddressUseCase(Get.find<AddressRepository>()),
      );
    }

    if (!Get.isRegistered<UpdateAddressUseCase>()) {
      Get.put<UpdateAddressUseCase>(
        UpdateAddressUseCase(Get.find<AddressRepository>()),
      );
    }

    if (!Get.isRegistered<DeleteAddressUseCase>()) {
      Get.put<DeleteAddressUseCase>(
        DeleteAddressUseCase(Get.find<AddressRepository>()),
      );
    }

    // Register LocationService
    if (!Get.isRegistered<LocationService>()) {
      Get.put<LocationService>(LocationService());
    }

    // Register AddressController - Use put instead of lazyPut for immediate availability
    Get.put<AddressController>(
      AddressController(
        getAddressesUseCase: Get.find<GetAddressesUseCase>(),
        createAddressUseCase: Get.find<CreateAddressUseCase>(),
        updateAddressUseCase: Get.find<UpdateAddressUseCase>(),
        deleteAddressUseCase: Get.find<DeleteAddressUseCase>(),
        locationService: Get.find<LocationService>(),
      ),
    );
  }
}
