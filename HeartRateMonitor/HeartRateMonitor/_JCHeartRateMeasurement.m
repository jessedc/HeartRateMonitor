// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JCHeartRateMeasurement.m instead.

#import "_JCHeartRateMeasurement.h"


const struct JCHeartRateMeasurementAttributes JCHeartRateMeasurementAttributes = {
	.beatsPerMinute = @"beatsPerMinute",
	.timestamp = @"timestamp",
};



const struct JCHeartRateMeasurementRelationships JCHeartRateMeasurementRelationships = {
	.heartRateMonitor = @"heartRateMonitor",
};






@implementation JCHeartRateMeasurementID
@end

@implementation _JCHeartRateMeasurement

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HeartRateMeasurement" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HeartRateMeasurement";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HeartRateMeasurement" inManagedObjectContext:moc_];
}

- (JCHeartRateMeasurementID*)objectID {
	return (JCHeartRateMeasurementID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"beatsPerMinuteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"beatsPerMinute"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic beatsPerMinute;



- (int32_t)beatsPerMinuteValue {
	NSNumber *result = [self beatsPerMinute];
	return [result intValue];
}


- (void)setBeatsPerMinuteValue:(int32_t)value_ {
	[self setBeatsPerMinute:@(value_)];
}


- (int32_t)primitiveBeatsPerMinuteValue {
	NSNumber *result = [self primitiveBeatsPerMinute];
	return [result intValue];
}

- (void)setPrimitiveBeatsPerMinuteValue:(int32_t)value_ {
	[self setPrimitiveBeatsPerMinute:@(value_)];
}





@dynamic timestamp;






@dynamic heartRateMonitor;

	






@end




