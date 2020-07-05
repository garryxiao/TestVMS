using com.etsoo.Core.Services;
using com.etsoo.Core.Utils;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using System.Security.Claims;
using System.Threading.Tasks;

namespace TestVMS.Controllers
{
    public abstract class CommonController : ControllerBase
    {
        public static CurrentUser CreateUser(ClaimsPrincipal principal, IPAddress ipAddress)
        {
            // Define the user
            var user = new CurrentUser(3, ipAddress);

            // Login if authenticated
            var identity = principal.Identity;
            if (identity.IsAuthenticated && identity.Name != null)
            {
                var userId = ParseUtil.TryParse<int>(identity.Name).GetValueOrDefault();
                user.Login(userId, 1, "en-US", new string[] { "Admin" });
            }

            // Return
            return user;
        }

        /// <summary>
        /// Async set operation result content
        /// </summary>
        /// <param name="result">Result</param>
        /// <returns>Task</returns>
        protected async Task ResultContentAsync(OperationResult result)
        {
            Response.ContentType = "application/json";
            await result.SerializeAsync(Response.Body, DataFormat.Json);
        }
    }
}