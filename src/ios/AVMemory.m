#import "AVMemory.h"

#import <mach/mach.h>
#import <mach/mach_host.h>

@implementation AVMemory

- (void)getmemory:(CDVInvokedUrlCommand*)command
{

    //NSString* name = [[command arguments] objectAtIndex:0];
    //NSString* msg = [NSString stringWithFormat: @"Hello, %@", name];

    //CDVPluginResult* result = [CDVPluginResult
    //                           resultWithStatus:CDVCommandStatus_OK
    //                           messageAsString:msg];

    //[self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    
    int availablePages            = vmStats.free_count;
    float availableMemory         = (float)availablePages*vm_page_size/1024./1024.;
    
    int activePages               = vmStats.active_count;
    float activeMemory            = (float)activePages*vm_page_size/1024./1024.;
    
    int inactivePages             = vmStats.inactive_count;
    float inactiveMemory          = (float)inactivePages*vm_page_size/1024./1024.;
    
    int wirePages                 = vmStats.wire_count;
    float wireMemory              = (float)wirePages*vm_page_size/1024./1024.;
    
    int pageoutsPages             = vmStats.pageouts;
    float pageoutsMemory          = (float)pageoutsPages*vm_page_size/1024./1024.;
    
    int hitsPages                 = vmStats.hits;
    float hitsMemory              = (float)hitsPages*vm_page_size/1024./1024.;
    
    int purgeable_countPages      = vmStats.purgeable_count;
    float purgeable_countMemory   = (float)purgeable_countPages*vm_page_size/1024./1024.;
    
    int speculative_countPages    = vmStats.speculative_count;
    float speculative_countMemory = (float)speculative_countPages*vm_page_size/1024./1024.;
    
    
    NSLog(@"AV: %f", availableMemory);
    NSLog(@"AC: %f", activeMemory);
    NSLog(@"IN: %f", inactiveMemory);
    NSLog(@"WI: %f", wireMemory);
    NSLog(@"PO: %f", pageoutsMemory);
    NSLog(@"HI: %f", hitsMemory);
    NSLog(@"PU: %f", purgeable_countMemory);
    NSLog(@"SP: %f", speculative_countMemory);
    
    
}

@end
