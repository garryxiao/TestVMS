using com.etsoo.Core.Application;
using com.etsoo.Core.Services;
using System.ComponentModel.DataAnnotations;
using TestVMS.App;

namespace TestVMS.Models
{
    /// <summary>
    /// Login token model
    /// </summary>
    public class LoginTokenModel : VehicleService.IdDataModel
    {
        /// <summary>
        /// Saved token
        /// </summary>
        [Required]
        public string Token { get; set; }

        /// <summary>
        /// Override to collect parameters
        /// </summary>
        /// <param name="data">Data</param>
        /// <param name="service">Service</param>
        public override void Parameterize(OperationData data, IService<int> service)
        {
            base.Parameterize(data, service);

            // Add parameters
            var paras = data.Parameters;

            paras.Add("ip", service.User.ClientIp.ToString());
            paras.Add("token", Token);
        }
    }
}
