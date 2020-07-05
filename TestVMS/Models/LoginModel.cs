using System.ComponentModel.DataAnnotations;
using TestVMS.App;

namespace TestVMS.Models
{
    /// <summary>
    /// Login model
    /// https://docs.microsoft.com/en-us/dotnet/api/system.componentmodel.dataannotations?view=netframework-4.8
    /// </summary>
    public class LoginModel : VehicleService.DataModel
    {
        /// <summary>
        /// Id, like number id, mobile, or email
        /// </summary>
        [Required]
        [StringLength(256, MinimumLength = 4)]
        public string Id { get; set; }

        /// <summary>
        /// Raw password
        /// </summary>
        [Required]
        [StringLength(30, MinimumLength = 4)]
        public string Password { get; set; }

        /// <summary>
        /// Is save login
        /// </summary>
        public bool? Save { get; set; }
    }
}
