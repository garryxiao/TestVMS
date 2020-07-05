using com.etsoo.Core.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Distributed;
using Microsoft.IdentityModel.Tokens;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using TestVMS.App;
using TestVMS.Models;

namespace TestVMS.Controllers
{
    /// <summary>
    /// User controller
    /// </summary>
    [ApiController]
    [Route("[controller]")]
    public class UserController : CommonController
    {
        protected IVMSApp App;

        /// <summary>
        /// Distributed cache
        /// </summary>
        protected IDistributedCache Cache { get; }

        // Simulated user id
        const int loginUser = 1001;

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="app">Application</param>
        /// <param name="distributedCache">Distributed cache</param>
        /// <param name="httpContextAccessor">Http context accessor</param>
        public UserController(IVMSApp app, IDistributedCache distributedCache, IHttpContextAccessor httpContextAccessor)
        {
            // App
            App = app;

            // Cache
            Cache = distributedCache;
        }

        private string CreateToken()
        {
            // Token handler
            var tokenHandler = new JwtSecurityTokenHandler();

            // Key bytes
            var key = Encoding.ASCII.GetBytes(App.Configuration.SymmetricKey);

            // Token descriptor
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.Name, loginUser.ToString())
                }),

                // Suggest to refresh it at 5 minutes interval, two times to update
                Expires = DateTime.UtcNow.AddMinutes(12),

                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256)
            };

            // Create the token
            var token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);
        }

        /// <summary>
        /// Login for authentication
        /// 登录授权
        /// </summary>
        /// <param name="model">Data model</param>
        /// <returns>Result</returns>
        [AllowAnonymous]
        [HttpPost("Login")]
        public async Task Login(LoginModel model)
        {
            // Act
            var result = new OperationResult();

            // Simulate successful login
            SimulateLogin(result);

            // Suggested refresh seconds
            result.Data["refresh_seconds"] = 300;

            // Output
            await ResultContentAsync(result);
        }

        private void SimulateLogin(OperationResult result)
        {
            // User id
            result.Data["token_user_id"] = loginUser;

            // Token for saved login
            result.Data["token"] = "SavedLoginToken";

            // Hold the token value and then return to client
            result.Data["authorization"] = CreateToken();

        }

        /// <summary>
        /// Login with token
        /// </summary>
        /// <param name="model">Data model</param>
        /// <returns>Result</returns>
        [AllowAnonymous]
        [HttpPost("LoginToken")]
        public async Task LoginToken(LoginTokenModel model)
        {
            var result = new OperationResult();

            // Simulate successful login
            SimulateLogin(result);

            // Output
            await ResultContentAsync(result);
        }

        /// <summary>
        /// Refresh the user token
        /// </summary>
        /// <returns>Token string</returns>
        [HttpPut("RefreshToken")]
        public async Task RefreshToken()
        {
            // Result
            var result = new OperationResult();

            // Recreate the token
            result.Data["authorization"] = CreateToken();

            // Output
            await ResultContentAsync(result);
        }

        /// <summary>
        /// Signout
        /// </summary>
        /// <param name="method">Login method</param>
        /// <param name="clear">Clear token</param>
        /// <returns>Action result</returns>
        [HttpPut("Signout")]
        public async Task Signout([FromQuery] byte method, bool clear)
        {
            await ResultContentAsync(new OperationResult());
        }
    }
}