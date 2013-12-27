// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JCHeartRateMeasurement.h instead.

#import <CoreData/CoreData.h>



extern const struct JCHeartRateMeasurementAttributes {
	__unsafe_unretained NSString *beatsPerMinute;
	__unsafe_unretained NSString *timestamp;
} JCHeartRateMeasurementAttributes;



extern const struct JCHeartRateMeasurementRelationships {
	__unsafe_unretained NSString *heartRateMonitor;
} JCHeartRateMeasurementRelationships;






@class JCHeartRateMonitor;






@interface JCHeartRateMeasurementID : NSManagedObjectID {}
@end

@interface _JCHeartRateMeasurement : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JCHeartRateMeasurementID*)objectID;





@property (nonatomic, strong) NSNumber* beatsPerMinute;




@property (atomic) int32_t beatsPerMinuteValue;
- (int32_t)beatsPerMinuteValue;
- (void)setBeatsPerMinuteValue:(int32_t)value_;


//- (BOOL)validateBeatsPerMinute:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* timestamp;



//- (BOOL)validateTimestamp:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) JCHeartRateMonitor *heartRateMonitor;

//- (BOOL)validateHeartRateMonitor:(id*)value_ error:(NSError**)error_;





@end



@interface _JCHeartRateMeasurement (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveBeatsPerMinute;
- (void)setPrimitiveBeatsPerMinute:(NSNumber*)value;

- (int32_t)primitiveBeatsPerMinuteValue;
- (void)setPrimitiveBeatsPerMinuteValue:(int32_t)value_;




- (NSDate*)primitiveTimestamp;
- (void)setPrimitiveTimestamp:(NSDate*)value;





- (JCHeartRateMonitor*)primitiveHeartRateMonitor;
- (void)setPrimitiveHeartRateMonitor:(JCHeartRateMonitor*)value;


@end
