// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JCHeartRateMonitor.h instead.

#import <CoreData/CoreData.h>



extern const struct JCHeartRateMonitorAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *manufacturerName;
} JCHeartRateMonitorAttributes;



extern const struct JCHeartRateMonitorRelationships {
	__unsafe_unretained NSString *measurements;
} JCHeartRateMonitorRelationships;






@class JCHeartRateMeasurement;






@interface JCHeartRateMonitorID : NSManagedObjectID {}
@end

@interface _JCHeartRateMonitor : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JCHeartRateMonitorID*)objectID;





@property (nonatomic, strong) NSString* identifier;



//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* manufacturerName;



//- (BOOL)validateManufacturerName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *measurements;

- (NSMutableSet*)measurementsSet;





@end


@interface _JCHeartRateMonitor (MeasurementsCoreDataGeneratedAccessors)
- (void)addMeasurements:(NSSet*)value_;
- (void)removeMeasurements:(NSSet*)value_;
- (void)addMeasurementsObject:(JCHeartRateMeasurement*)value_;
- (void)removeMeasurementsObject:(JCHeartRateMeasurement*)value_;
@end


@interface _JCHeartRateMonitor (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;




- (NSString*)primitiveManufacturerName;
- (void)setPrimitiveManufacturerName:(NSString*)value;





- (NSMutableSet*)primitiveMeasurements;
- (void)setPrimitiveMeasurements:(NSMutableSet*)value;


@end
