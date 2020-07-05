namespace TestVMS
{
    /// <summary>
    /// VMS Settings
    /// </summary>
    public class VMSSettings
    {
        /// <summary>
        /// Connection string id, comply with ConnectionStrings/{id} database configuration node
        /// </summary>
        public string ConnectionStringId { get; set; }

        /// <summary>
        /// CORS (Cross-Origin Requests) allowed sites, support similar *.etsoo.com subdomains
        /// </summary>
        public string[] Cors { get; set; }

        /// <summary>
        /// Is SSL only
        /// </summary>
        public bool SSL { get; set; }

        /// <summary>
        /// Symmetric security key, for exchange
        /// </summary>
        public string SymmetricKey { get; set; }
    }
}