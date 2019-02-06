// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Microsoft.Azure.PowerShell.Cmdlets.Peering.Common.Models
{
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// The peering location class.
    /// </summary>
    [Rest.Serialization.JsonTransformation]
    public partial class PSPeeringLocation
    {
        /// <summary>
        /// Initializes a new instance of the PSPeeringLocation class.
        /// </summary>
        public PSPeeringLocation()
        {
            CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the PSPeeringLocation class.
        /// </summary>
        /// <param name="kind">Gets or sets the kind. Possible values include:
        /// 'Direct', 'Exchange', 'Partner'</param>
        /// <param name="direct">Gets or sets the peering direct
        /// properties.</param>
        /// <param name="exchange">Gets or sets the peering exchange
        /// properties.</param>
        /// <param name="peeringLocation">Gets or sets the peering
        /// location.</param>
        /// <param name="country">Gets or sets the country.</param>
        /// <param name="azureRegion">Gets or sets the azure region for the
        /// location.</param>
        /// <param name="name">Gets or sets the resource name.</param>
        /// <param name="id">Gets or sets the resource id.</param>
        /// <param name="type">Gets or sets the resource type.</param>
        public PSPeeringLocation(string kind = default(string), PSPeeringLocationPropertiesDirect direct = default(PSPeeringLocationPropertiesDirect), PSPeeringLocationPropertiesExchange exchange = default(PSPeeringLocationPropertiesExchange), string peeringLocation = default(string), string country = default(string), string azureRegion = default(string), string name = default(string), string id = default(string), string type = default(string))
        {
            Kind = kind;
            Direct = direct;
            Exchange = exchange;
            PeeringLocation = peeringLocation;
            Country = country;
            AzureRegion = azureRegion;
            Name = name;
            Id = id;
            Type = type;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the kind. Possible values include: 'Direct',
        /// 'Exchange', 'Partner'
        /// </summary>
        [JsonProperty(PropertyName = "kind")]
        public string Kind { get; set; }

        /// <summary>
        /// Gets or sets the peering direct properties.
        /// </summary>
        [JsonProperty(PropertyName = "properties.direct")]
        public PSPeeringLocationPropertiesDirect Direct { get; set; }

        /// <summary>
        /// Gets or sets the peering exchange properties.
        /// </summary>
        [JsonProperty(PropertyName = "properties.exchange")]
        public PSPeeringLocationPropertiesExchange Exchange { get; set; }

        /// <summary>
        /// Gets or sets the peering location.
        /// </summary>
        [JsonProperty(PropertyName = "properties.peeringLocation")]
        public string PeeringLocation { get; set; }

        /// <summary>
        /// Gets or sets the country.
        /// </summary>
        [JsonProperty(PropertyName = "properties.country")]
        public string Country { get; set; }

        /// <summary>
        /// Gets or sets the azure region for the location.
        /// </summary>
        [JsonProperty(PropertyName = "properties.azureRegion")]
        public string AzureRegion { get; set; }

        /// <summary>
        /// Gets or sets the resource name.
        /// </summary>
        [JsonProperty(PropertyName = "name")]
        public string Name { get; private set; }

        /// <summary>
        /// Gets or sets the resource id.
        /// </summary>
        [JsonProperty(PropertyName = "id")]
        public string Id { get; private set; }

        /// <summary>
        /// Gets or sets the resource type.
        /// </summary>
        [JsonProperty(PropertyName = "type")]
        public string Type { get; private set; }

    }
}