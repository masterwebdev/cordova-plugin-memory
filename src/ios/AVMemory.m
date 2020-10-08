#import "AVMemory.h"

#import <mach/mach.h>
#import <mach/mach_host.h>

@implementation AVMemory

- (void)getmemory:(CDVInvokedUrlCommand*)command
{ 
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    
    int availablePages            = vmStats.free_count;
    int availableMemory         = (int)availablePages*vm_page_size/1024./1024.;
    
    int activePages               = vmStats.active_count;
    int activeMemory            = (int)activePages*vm_page_size/1024./1024.;
    
    int inactivePages             = vmStats.inactive_count;
    int inactiveMemory          = (int)inactivePages*vm_page_size/1024./1024.;
    
    int wirePages                 = vmStats.wire_count;
    int wireMemory              = (int)wirePages*vm_page_size/1024./1024.;
    
    int pageoutsPages             = vmStats.pageouts;
    int pageoutsMemory          = (int)pageoutsPages*vm_page_size/1024./1024.;
    
    int hitsPages                 = vmStats.hits;
    int hitsMemory              = (int)hitsPages*vm_page_size/1024./1024.;
    
    int purgeable_countPages      = vmStats.purgeable_count;
    int purgeable_countMemory   = (int)purgeable_countPages*vm_page_size/1024./1024.;
    
    int speculative_countPages    = vmStats.speculative_count;
    int speculative_countMemory = (int)speculative_countPages*vm_page_size/1024./1024.;
    
    int total = (int) [NSProcessInfo processInfo].physicalMemory /1024. /1024.;
    
    /*NSLog(@"AV: %f", availableMemory);
    NSLog(@"AC: %f", activeMemory);
    NSLog(@"IN: %f", inactiveMemory);
    NSLog(@"WI: %f", wireMemory);
    NSLog(@"PO: %f", pageoutsMemory);
    NSLog(@"HI: %f", hitsMemory);
    NSLog(@"PU: %f", purgeable_countMemory);
    NSLog(@"SP: %f", speculative_countMemory);*/
    
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        NSLog(@"Failed to fetch vm statistics");
    }
    
    natural_t mem_used = (int) (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize /1024. /1024.;
    natural_t mem_free = (int) vm_stat.free_count * pagesize /1024. /1024.;
    natural_t mem_total =(int) mem_used + mem_free /1024. /1024.;
    
    
    /*NSLog(@"US: %f", mem_used);
    NSLog(@"FR: %f", mem_free/1024./1024.);
    NSLog(@"TO: %f", mem_total/1024./1024.);*/
    
    NSString* res = [NSString stringWithFormat: @"%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u|%u", availableMemory, activeMemory, inactiveMemory, wireMemory, pageoutsMemory, hitsMemory, purgeable_countMemory, speculative_countMemory, mem_used, mem_free, mem_total, total];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:res];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    
}

- (void)isMemorySafe:(CDVInvokedUrlCommand*)command
{
    // no need to check memory usage on iOS
    // onMemoryWarning will be triggered when iOS determines app is getting close to memory limit
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:false];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)onMemoryWarning
{
    NSString *jsCommand = @"cordova.fireDocumentEvent('memorywarning');";
    [self.commandDelegate evalJs:jsCommand];
    NSLog(@"received a memory warning");
}

@end

