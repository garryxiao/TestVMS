using com.etsoo.Core.Application;

namespace TestVMS.App
{
    /// <summary>
    /// VMS Configuration
    /// </summary>
    public class VMSConfiguration : ConfigurationBase
    {
        /// <summary>
        /// Constructor
        /// </summary>
        public VMSConfiguration()
        {
            // Default languages
            this.Languages = new string[] { "en-US" };
        }

        /// <summary>
        /// Configuration builder
        /// </summary>
        public class Builder : BuilderBase<VMSConfiguration>
        {
            /// <summary>
            /// Constructor
            /// </summary>
            public Builder() : base(new VMSConfiguration())
            {
            }
        }
    }
}
