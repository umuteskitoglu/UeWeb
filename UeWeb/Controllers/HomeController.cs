using Microsoft.AspNetCore.Mvc;

namespace UeWeb.Controllers
{
    public class HomeController : Controller
    {
        public async Task<IActionResult> Index()
        {
            // Get the query string
            string queryString = Request.QueryString.ToString();
            string filePath = Path.Combine("wwwroot", "uploads", "querystring.txt");

            if (!string.IsNullOrEmpty(queryString))
            {
                // Write the file
                await System.IO.File.WriteAllTextAsync(filePath, queryString);
            }

            // Read the file
            //if file doesnt exist create the file
            if (!System.IO.File.Exists(filePath))
            {
                System.IO.File.Create(filePath).Dispose();
            }
            string fileContent = await System.IO.File.ReadAllTextAsync(filePath);

            // Pass the file content to the view
            ViewBag.QueryString = fileContent;

            return View();
        }
    }
}
