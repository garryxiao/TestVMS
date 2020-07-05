using com.etsoo.Core.Application;
using com.etsoo.Core.Services;
using System;
using System.ComponentModel.DataAnnotations;
using TestVMS.App;

namespace TestVMS.Models
{
    /// <summary>
    /// Vehicle edit model
    /// </summary>
    public class VehicleEditModel : VehicleService.IdDataModel
    {
        /// <summary>
        /// Device id of the black box
        /// </summary>
        public Guid? DeviceId { get; set; }

        /// <summary>
        /// Plate no of the vehicle
        /// </summary>
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
        /// Override to validate data
        /// </summary>
        /// <param name="result">Result</param>
        public override void Validate(OperationResult result)
        {
            base.Validate(result);

            if (result.OK)
            {
                if (Id.GetValueOrDefault() < 1)
                {
                    result.SetError(-1, "id", "The id of the entity missed", "id_error");
                }
            }
        }

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

            if (DeviceId != null && !DeviceId.Value.Equals(Guid.Empty))
                paras.Add("device_id", DeviceId);

            if (!string.IsNullOrEmpty(PlateNo))
                paras.Add("plate_no", PlateNo);

            paras.Add("fleet_id", FleetId);

            if (Description != null)
                paras.Add("description", Description.Trim());
        }
    }
}