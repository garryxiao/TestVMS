using com.etsoo.Core.Application;
using com.etsoo.Core.Services;
using System;
using System.ComponentModel.DataAnnotations;
using TestVMS.App;

namespace TestVMS.Models
{
    /// <summary>
    /// Vehicle add model
    /// </summary>
    public class VehicleAddModel : VehicleService.DataModel
    {
        /// <summary>
        /// Device id of the black box
        /// </summary>
        [Required]
        public Guid? DeviceId { get; set; }

        /// <summary>
        /// Plate no of the vehicle
        /// </summary>
        [Required]
        [StringLength(8, MinimumLength = 6)]
        public string PlateNo { get; set; }

        /// <summary>
        /// Fleet id for grouping
        /// </summary>
        public int? FleetId { get; set; }

        /// <summary>
        /// Description
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// Override to collect parameters
        /// </summary>
        /// <param name="data">Operation data</param>
        /// <param name="service">Service</param>
        public override void Parameterize(OperationData data, IService<int> service)
        {
            base.Parameterize(data, service);

            // Add parameters
            var paras = data.Parameters;

            paras.Add("device_id", DeviceId);
            paras.Add("plate_no", PlateNo);
            paras.Add("fleet_id", FleetId);
            if (!string.IsNullOrEmpty(Description)) paras.Add("description", Description);
        }
    }
}
