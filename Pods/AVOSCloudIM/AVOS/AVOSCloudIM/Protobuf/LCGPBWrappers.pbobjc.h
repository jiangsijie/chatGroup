// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: google/protobuf/wrappers.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(LCGPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define LCGPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if LCGPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <protobuf/LCGPBDescriptor.h>
 #import <protobuf/LCGPBMessage.h>
 #import <protobuf/LCGPBRootObject.h>
#else
 #import "LCGPBDescriptor.h"
 #import "LCGPBMessage.h"
 #import "LCGPBRootObject.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

NS_ASSUME_NONNULL_BEGIN

#pragma mark - LCGPBWrappersRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (LCGPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c LCGPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface LCGPBWrappersRoot : LCGPBRootObject
@end

#pragma mark - LCGPBDoubleValue

typedef LCGPB_ENUM(LCGPBDoubleValue_FieldNumber) {
  LCGPBDoubleValue_FieldNumber_Value = 1,
};

/**
 * Wrapper message for `double`.
 *
 * The JSON representation for `DoubleValue` is JSON number.
 **/
@interface LCGPBDoubleValue : LCGPBMessage

/** The double value. */
@property(nonatomic, readwrite) double value;

@end

#pragma mark - LCGPBFloatValue

typedef LCGPB_ENUM(LCGPBFloatValue_FieldNumber) {
  LCGPBFloatValue_FieldNumber_Value = 1,
};

/**
 * Wrapper message for `float`.
 *
 * The JSON representation for `FloatValue` is JSON number.
 **/
@interface LCGPBFloatValue : LCGPBMessage

/** The float value. */
@property(nonatomic, readwrite) float value;

@end

#pragma mark - LCGPBInt64Value

typedef LCGPB_ENUM(LCGPBInt64Value_FieldNumber) {
  LCGPBInt64Value_FieldNumber_Value = 1,
};

/**
 * Wrapper message for `int64`.
 *
 * The JSON representation for `Int64Value` is JSON string.
 **/
@interface LCGPBInt64Value : LCGPBMessage

/** The int64 value. */
@property(nonatomic, readwrite) int64_t value;

@end

#pragma mark - LCGPBUInt64Value

typedef LCGPB_ENUM(LCGPBUInt64Value_FieldNumber) {
  LCGPBUInt64Value_FieldNumber_Value = 1,
};

/**
 * Wrapper message for `uint64`.
 *
 * The JSON representation for `UInt64Value` is JSON string.
 **/
@interface LCGPBUInt64Value : LCGPBMessage

/** The uint64 value. */
@property(nonatomic, readwrite) uint64_t value;

@end

#pragma mark - LCGPBInt32Value

typedef LCGPB_ENUM(LCGPBInt32Value_FieldNumber) {
  LCGPBInt32Value_FieldNumber_Value = 1,
};

/**
 * Wrapper message for `int32`.
 *
 * The JSON representation for `Int32Value` is JSON number.
 **/
@interface LCGPBInt32Value : LCGPBMessage

/** The int32 value. */
@property(nonatomic, readwrite) int32_t value;

@end

#pragma mark - LCGPBUInt32Value

typedef LCGPB_ENUM(LCGPBUInt32Value_FieldNumber) {
  LCGPBUInt32Value_FieldNumber_Value = 1,
};

/**
 * Wrapper message for `uint32`.
 *
 * The JSON representation for `UInt32Value` is JSON number.
 **/
@interface LCGPBUInt32Value : LCGPBMessage

/** The uint32 value. */
@property(nonatomic, readwrite) uint32_t value;

@end

#pragma mark - LCGPBBoolValue

typedef LCGPB_ENUM(LCGPBBoolValue_FieldNumber) {
  LCGPBBoolValue_FieldNumber_Value = 1,
};

/**
 * Wrapper message for `bool`.
 *
 * The JSON representation for `BoolValue` is JSON `true` and `false`.
 **/
@interface LCGPBBoolValue : LCGPBMessage

/** The bool value. */
@property(nonatomic, readwrite) BOOL value;

@end

#pragma mark - LCGPBStringValue

typedef LCGPB_ENUM(LCGPBStringValue_FieldNumber) {
  LCGPBStringValue_FieldNumber_Value = 1,
};

/**
 * Wrapper message for `string`.
 *
 * The JSON representation for `StringValue` is JSON string.
 **/
@interface LCGPBStringValue : LCGPBMessage

/** The string value. */
@property(nonatomic, readwrite, copy, null_resettable) NSString *value;

@end

#pragma mark - LCGPBBytesValue

typedef LCGPB_ENUM(LCGPBBytesValue_FieldNumber) {
  LCGPBBytesValue_FieldNumber_Value = 1,
};

/**
 * Wrapper message for `bytes`.
 *
 * The JSON representation for `BytesValue` is JSON string.
 **/
@interface LCGPBBytesValue : LCGPBMessage

/** The bytes value. */
@property(nonatomic, readwrite, copy, null_resettable) NSData *value;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
