// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JCHeartRateMonitor.m instead.

#import "_JCHeartRateMonitor.h"


const struct JCHeartRateMonitorAttributes JCHeartRateMonitorAttributes = {
	.identifier = @"identifier",
	.manufacturerName = @"manufacturerName",
};



const struct JCHeartRateMonitorRelationships JCHeartRateMonitorRelationships = {
	.measurements = @"measurements",
};






@implementation JCHeartRateMonitorID
@end

@implementation _JCHeartRateMonitor

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HeartRateMonitor" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HeartRateMonitor";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HeartRateMonitor" inManagedObjectContext:moc_];
}

- (JCHeartRateMonitorID*)objectID {
	return (JCHeartRateMonitorID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic identifier;






@dynamic manufacturerName;






@dynamic measurements;

	
- (NSMutableSet*)measurementsSet {
	[self willAccessValueForKey:@"measurements"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"measurements"];
  
	[self didAccessValueForKey:@"measurements"];
	return result;
}
	






@end




