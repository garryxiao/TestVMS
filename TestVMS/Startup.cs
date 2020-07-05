using com.etsoo.Core.Database;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.ResponseCompression;
using Microsoft.AspNetCore.SpaServices.ReactDevelopmentServer;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using System.IO.Compression;
using System.Text;
using TestVMS.App;

namespace TestVMS
{
    public class Startup
    {
        /// <summary>
        /// Local configuration
        /// </summary>
        public IConfiguration Configuration { get; }

        /// <summary>
        /// VMS Settings
        /// </summary>
        VMSSettings Settings { get; }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="configuration">Configuration</param>
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;

            // VMS Settings
            Settings = Configuration.GetSection("AppSettings:VMS").Get<VMSSettings>();
        }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            // services.AddControllersWithViews();

            // In production, the React files will be served from this directory
            services.AddSpaStaticFiles(configuration =>
            {
                configuration.RootPath = "ClientApp/build";
            });

            // Dependency Injection for the MainApp
            // https://stackoverflow.com/questions/38138100/addtransient-addscoped-and-addsingleton-services-differences
            // Add as singleton to enhance performance
            services.AddSingleton<IVMSApp>(new VMSApp(
                // Configurations
                (configuration) =>
                {
                    configuration
                        .ModelValidated(true)
                        .SetKeys(string.Empty, Settings.SymmetricKey)
                    ;
                },

                // Database context
                new SqlServerDatabase(Configuration.GetConnectionString(Settings.ConnectionStringId))
            ));

            // Add to support access HttpContext
            services.AddHttpContextAccessor();

            // Configure distributed memory cache
            // https://dotnetcoretutorials.com/2017/03/05/using-inmemory-cache-net-core/
            services.AddDistributedMemoryCache();

            // Configue CORS
            if (Settings.Cors?.Length > 0)
            {
                services.AddCors(options =>
                {
                    options.AddPolicy("platform",
                    builder =>
                    {
                        builder.WithOrigins(Settings.Cors)
                            // Support https://*.domain.com
                            .SetIsOriginAllowedToAllowWildcardSubdomains()

                            // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Credentials
                            // https://stackoverflow.com/questions/24687313/what-exactly-does-the-access-control-allow-credentials-header-do
                            // JWT is not a cookie solution, disable it without allow credential
                            // .AllowCredentials()
                            .DisallowCredentials()

                            // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers
                            // Without it will popup error: Request header field content-type is not allowed by Access-Control-Allow-Headers in preflight response
                            .AllowAnyHeader()

                            // Web Verbs like GET, POST, default enabled
                            .AllowAnyMethod();
                    });
                });
            }

            // Configue compression
            // https://gunnarpeipman.com/aspnet-core-compress-gzip-brotli-content-encoding/
            services.Configure<BrotliCompressionProviderOptions>(options =>
            {
                options.Level = CompressionLevel.Optimal;
            });

            services.AddResponseCompression(options =>
            {
                options.EnableForHttps = true;
                options.Providers.Add<BrotliCompressionProvider>();
            });

            // Configue JWT authentication
            // https://jwt.io/
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    // Is SSL only
                    options.RequireHttpsMetadata = Settings.SSL;

                    // Save token, True means tokens are cached in the server for validation
                    options.SaveToken = false;

                    // Token validation parameters
                    options.TokenValidationParameters = new TokenValidationParameters()
                    {
                        ValidateIssuerSigningKey = true,
                        RequireExpirationTime = true,
                        ValidateLifetime = true,

                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(Settings.SymmetricKey)),
                        ValidateIssuer = false,
                        ValidateAudience = false
                    };
                });

            // Register controllers
            services.AddControllers();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            // Enable HTTPS redirect
            if (Settings.SSL)
                app.UseHttpsRedirection();

            app.UseHttpsRedirection();
            app.UseStaticFiles();
            app.UseSpaStaticFiles();

            app.UseRouting();

            // Enable CORS (Cross-Origin Requests)
            // The call to UseCors must be placed after UseRouting, but before UseAuthorization
            if (Settings.Cors?.Length > 0)
            {
                app.UseCors("platform");
            }

            app.UseAuthentication();
            app.UseAuthorization();

            // Enable compression
            app.UseResponseCompression();

            app.UseEndpoints(endpoints =>
            {
                // Apply authentication by default
                endpoints.MapControllers().RequireAuthorization();
            });

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllerRoute(
                    name: "default",
                    pattern: "{controller}/{action=Index}/{id?}");
            });

            app.UseSpa(spa =>
            {
                spa.Options.SourcePath = "ClientApp";

                if (env.IsDevelopment())
                {
                    spa.UseReactDevelopmentServer(npmScript: "start");
                }
            });
        }
    }
}