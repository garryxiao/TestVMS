using com.etsoo.Core.Application;
using com.etsoo.Core.Services;

namespace TestVMS.App
{
    /// <summary>
    /// Vehicle Service
    /// </summary>
    public class VehicleService : Service<int>
    {
        /// <summary>
        /// Create service
        /// Avoid generics with 'new' constraint for Activator.Create performance issue
        /// </summary>
        /// <param name="app">Application</param>
        /// <param name="user">Current user</param>
        /// <returns>Service</returns>
        public static VehicleService Create(IVMSApp app, ICurrentUser user)
        {
            var service = new VehicleService();
            service.Application = app;
            service.User = user;
            return service;
        }

        /// <summary>
        /// Service identity
        /// </summary>
        public override string Identity
        {
            get
            {
                return "vehicle";
            }
        }

        /// <summary>
        /// Module id
        /// </summary>
        public override byte ModuleId
        {
            get
            {
                // Not applied, return zero
                return 0;
            }
        }

        /// <summary>
        /// System check before database operation
        /// </summary>
        /// <param name="data">Operation data</param>
        /// <returns>Result</returns>
        override protected OperationResult SystemCheck(OperationData data)
        {
            // Action result
            var result = new OperationResult();

            // User logined?
            if (User.IsAuthenticated)
            {
                // Add system parameters
                SystemUserParameters(data);
            }
            else
            {
                // Login required
                result.SetError(-1, "id", "user_login_invalid");
            }

            // Return
            return result;
        }

        /// <summary>
        /// Add system user parameters
        /// </summary>
        /// <param name="data">Operation data</param>
        override protected void SystemUserParameters(OperationData data)
        {
            // Pass the current user id
            data.Parameters.Add("user_application_id", User.Id);
        }
    }
}
