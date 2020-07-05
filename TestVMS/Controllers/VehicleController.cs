using com.etsoo.Core.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Distributed;
using System.Threading.Tasks;
using TestVMS.App;
using TestVMS.Models;

namespace TestVMS.Controllers
{
    /// <summary>
    /// Vehicle controller
    /// </summary>
    [ApiController]
    [Route("[controller]")]
    public class VehicleController : CommonController
    {
        /// <summary>
        /// Distributed cache
        /// </summary>
        protected IDistributedCache Cache { get; }

        /// <summary>
        /// Service
        /// </summary>
        protected VehicleService Service { get; }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="app">Application</param>
        /// <param name="distributedCache">Distributed cache</param>
        /// <param name="httpContextAccessor">Http context accessor</param>
        public VehicleController(IVMSApp app, IDistributedCache distributedCache, IHttpContextAccessor httpContextAccessor)
        {
            // Define the user
            var user = CreateUser(httpContextAccessor.HttpContext.User, httpContextAccessor.HttpContext.Connection.RemoteIpAddress);

            // Service
            Service = VehicleService.Create(app, user);

            // Cache
            Cache = distributedCache;
        }

        /// <summary>
        /// Get for search with parameters
        /// </summary>
        /// <param name="model">Model</param>
        [HttpGet]
        public async Task Get([FromQuery] VehicleSearchModel model)
        {
            Response.ContentType = "application/json";
            await Service.SearchJsonAsync(Response.Body, model.Domain, model);
        }

        /// <summary>
        /// Get for view
        /// </summary>
        /// <param name="id">Vehicle entity id</param>
        [HttpGet("{id}")]
        public async Task Get(int id)
        {
            Response.ContentType = "application/json";
            await Service.ViewJsonAsync(Response.Body, id, null);
        }

        /// <summary>
        /// Post for add vehicle
        /// </summary>
        /// <param name="model">Model</param>
        [HttpPost]
        public async Task Post([FromBody] VehicleAddModel model)
        {
            await ResultContentAsync(await Service.AddEntityAsync(model));
        }

        /// <summary>
        /// Put for edit vehicle
        /// </summary>
        /// <param name="id">Vehicle entity id</param>
        /// <param name="model">Model</param>
        [HttpPut("{id}")]
        public async Task Put(int id, [FromBody] VehicleEditModel model)
        {
            // Merge the id
            model.Id = id;

            await ResultContentAsync(await Service.EditEntityAsync(model));
        }

        /// <summary>
        /// Delete vehicle
        /// </summary>
        /// <param name="id">Vehicle entity id</param>
        [HttpDelete("{id}")]
        public async Task Delete(int id)
        {
            await ResultContentAsync(await Service.DeleteEntityAsync(new int[] { id }));
        }
    }
}