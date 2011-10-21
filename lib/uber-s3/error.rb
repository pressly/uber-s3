class UberS3
  
  module Error
  
    class Standard < StandardError
      def initialize(key, message)
        super("#{key}: #{message}")
      end
    end
  
    class Unknown < StandardError; end
    
    class AccessDenied < Standard; end
    class AccountProblem < Standard; end
    class AmbiguousGrantByEmailAddress < Standard; end
    class BadDigest < Standard; end
    class BucketAlreadyExists < Standard; end
    class BucketAlreadyOwnedByYou < Standard; end
    class BucketNotEmpty < Standard; end
    class CredentialsNotSupported < Standard; end
    class CrossLocationLoggingProhibited < Standard; end
    class EntityTooSmall < Standard; end
    class EntityTooLarge < Standard; end
    class ExpiredToken < Standard; end
    class IllegalVersioningConfigurationException < Standard; end
    class IncompleteBody < Standard; end
    class IncorrectNumberOfFilesInPostRequest < Standard; end
    class InlineDataTooLarge < Standard; end
    class InternalError < Standard; end
    class InvalidAccessKeyId < Standard; end
    class InvalidAddressingHeader < Standard; end
    class InvalidArgument < Standard; end
    class InvalidBucketName < Standard; end
    class InvalidDigest < Standard; end
    class InvalidLocationConstraint < Standard; end
    class InvalidPart < Standard; end
    class InvalidPartOrder < Standard; end
    class InvalidPayer < Standard; end
    class InvalidPolicyDocument < Standard; end
    class InvalidRange < Standard; end
    class InvalidRequest < Standard; end
    class InvalidSecurity < Standard; end
    class InvalidSOAPRequest < Standard; end
    class InvalidStorageClass < Standard; end
    class InvalidTargetBucketForLogging < Standard; end
    class InvalidToken < Standard; end
    class InvalidURI < Standard; end
    class KeyTooLong < Standard; end
    class MalformedACLError < Standard; end
    class MalformedPOSTRequest < Standard; end
    class MalformedXML < Standard; end
    class MaxMessageLengthExceeded < Standard; end
    class MaxPostPreDataLengthExceededError < Standard; end
    class MetadataTooLarge < Standard; end
    class MethodNotAllowed < Standard; end
    class MissingAttachment < Standard; end
    class MissingContentLength < Standard; end
    class MissingRequestBodyError < Standard; end
    class MissingSecurityElement < Standard; end
    class MissingSecurityHeader < Standard; end
    class NoLoggingStatusForKey < Standard; end
    class NoSuchBucket < Standard; end
    class NoSuchKey < Standard; end
    class NoSuchUpload < Standard; end
    class NoSuchVersion < Standard; end
    class NotImplemented < Standard; end
    class NotSignedUp < Standard; end
    class NotSuchBucketPolicy < Standard; end
    class OperationAborted < Standard; end
    class PermanentRedirect < Standard; end
    class PreconditionFailed < Standard; end
    class Redirect < Standard; end
    class RequestIsNotMultiPartContent < Standard; end
    class RequestTimeout < Standard; end
    class RequestTimeTooSkewed < Standard; end
    class RequestTorrentOfBucketError < Standard; end
    class SignatureDoesNotMatch < Standard; end
    class ServiceUnavailable < Standard; end
    class SlowDown < Standard; end
    class TemporaryRedirect < Standard; end
    class TokenRefreshRequired < Standard; end
    class TooManyBuckets < Standard; end
    class UnexpectedContent < Standard; end
    class UnresolvableGrantByEmailAddress < Standard; end
    class UserKeyMustBeSpecified < Standard; end

  end

end
