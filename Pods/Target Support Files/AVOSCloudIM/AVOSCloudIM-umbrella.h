#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AVIMMessageOption.h"
#import "AVIMKeyedConversation.h"
#import "AVIMConversationQuery.h"
#import "AVIMTextMessage.h"
#import "AVIMRecalledMessage.h"
#import "AVIMLocationMessage.h"
#import "AVIMAudioMessage.h"
#import "AVIMVideoMessage.h"
#import "AVIMFileMessage.h"
#import "AVIMTypedMessage.h"
#import "AVIMImageMessage.h"
#import "AVIMClient.h"
#import "AVIMCommon.h"
#import "AVIMConversation.h"
#import "AVIMMessage.h"
#import "AVIMSignature.h"
#import "AVIMClientProtocol.h"
#import "AVIMConversationMemberInfo.h"
#import "AVIMClientInternalConversationManager.h"
#import "AVOSCloudIM.h"
#import "LCGPBAny.pbobjc.h"
#import "LCGPBApi.pbobjc.h"
#import "LCGPBArray.h"
#import "LCGPBArray_PackagePrivate.h"
#import "LCGPBBootstrap.h"
#import "LCGPBCodedInputStream.h"
#import "LCGPBCodedInputStream_PackagePrivate.h"
#import "LCGPBCodedOutputStream.h"
#import "LCGPBCodedOutputStream_PackagePrivate.h"
#import "LCGPBDescriptor.h"
#import "LCGPBDescriptor_PackagePrivate.h"
#import "LCGPBDictionary.h"
#import "LCGPBDictionary_PackagePrivate.h"
#import "LCGPBDuration.pbobjc.h"
#import "LCGPBEmpty.pbobjc.h"
#import "LCGPBExtensionInternals.h"
#import "LCGPBExtensionRegistry.h"
#import "LCGPBFieldMask.pbobjc.h"
#import "LCGPBMessage.h"
#import "LCGPBMessage_PackagePrivate.h"
#import "LCGPBProtocolBuffers.h"
#import "LCGPBProtocolBuffers_RuntimeSupport.h"
#import "LCGPBRootObject.h"
#import "LCGPBRootObject_PackagePrivate.h"
#import "LCGPBRuntimeTypes.h"
#import "LCGPBSourceContext.pbobjc.h"
#import "LCGPBStruct.pbobjc.h"
#import "LCGPBTimestamp.pbobjc.h"
#import "LCGPBType.pbobjc.h"
#import "LCGPBUnknownField.h"
#import "LCGPBUnknownFieldSet.h"
#import "LCGPBUnknownFieldSet_PackagePrivate.h"
#import "LCGPBUnknownField_PackagePrivate.h"
#import "LCGPBUtilities.h"
#import "LCGPBUtilities_PackagePrivate.h"
#import "LCGPBWellKnownTypes.h"
#import "LCGPBWireFormat.h"
#import "LCGPBWrappers.pbobjc.h"
#import "MessagesProtoOrig.pbobjc.h"

FOUNDATION_EXPORT double AVOSCloudIMVersionNumber;
FOUNDATION_EXPORT const unsigned char AVOSCloudIMVersionString[];

