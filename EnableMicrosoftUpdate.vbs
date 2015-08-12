'Found at http://msdn.microsoft.com/en-us/library/windows/desktop/aa826676%28v=vs.85%29.aspx AFTER I went through a whole pain in the ass to take a snapshot of a VM before and after I enabled Microsoft Updates with a full install of Office and then compared it to after to find the damned registry keys needed.
Set ServiceManager = CreateObject("Microsoft.Update.ServiceManager")
ServiceManager.ClientApplicationID = "My App"

'add the Microsoft Update Service, GUID
Set NewUpdateService = ServiceManager.AddService2("7971f918-a847-4430-9279-4a52d1efe18d",7,"")
