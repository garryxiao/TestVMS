using com.etsoo.Core.Application;
using com.etsoo.Core.Database;
using com.etsoo.Core.Storage;
using System;

namespace TestVMS.App
{
    /// <summary>
    /// VMS Application
    /// </summary>
    public class VMSApp : ApplicationBase, IVMSApp
    {
        // Create configuration
        private static VMSConfiguration CreateConfiguration(Action<VMSConfiguration.Builder> action)
        {
            // Create a builder
            var builder = new VMSConfiguration.Builder();

            // Call action to collect properties
            action(builder);

            // Build and return
            return builder.Build();
        }

        /// <summary>
        /// Configuration
        /// </summary>
        public new VMSConfiguration Configuration { get; }

        /// <summary>
        /// Database
        /// </summary>
        public new SqlServerDatabase Database { get; }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="configuration">Configuration</param>
        /// <param name="database">Database</param>
        public VMSApp(VMSConfiguration configuration, SqlServerDatabase database) : base(configuration, database, new LocalStorage())
        {
            Configuration = configuration;
            Database = database;
        }

        /// <summary>
        /// Constructor with configuration delegate
        /// </summary>
        /// <param name="configurationAction">Configuration delegate</param>
        /// <param name="database">Database</param>
        public VMSApp(Action<VMSConfiguration.Builder> configurationAction, SqlServerDatabase database) : this(CreateConfiguration(configurationAction), database)
        {
        }
    }
}