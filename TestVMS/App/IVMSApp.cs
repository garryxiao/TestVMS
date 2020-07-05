using com.etsoo.Core.Application;
using com.etsoo.Core.Database;

namespace TestVMS.App
{
    /// <summary>
    /// VMS App Interface
    /// </summary>
    public interface IVMSApp : IApplication
    {
        /// <summary>
        /// Configuration
        /// </summary>
        new VMSConfiguration Configuration { get; }

        /// <summary>
        /// Database
        /// </summary>
        new SqlServerDatabase Database { get; }
    }
}