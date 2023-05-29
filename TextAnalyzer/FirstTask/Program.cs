using System.Reflection;
using System.Text;
using Dll;

namespace FirstTask
{
    internal class Program
    {

        private const string FolderPath = "..\\..\\..\\Resources\\";

        static void Main()
        {
            Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
            Console.WriteLine("Please enter name of the file (without .txt)");

            var name = Console.ReadLine();

            if (name is null) throw new ArgumentNullException();

            var path = Path.Combine(FolderPath, name + ".txt");
            var resultFile = Path.Combine(FolderPath, "Result.txt");

            if (!File.Exists(path))
            {
                Console.WriteLine("Place your file in the resources folder");
            }
            var allText = File.ReadAllText(path, Encoding.GetEncoding(1251));



            var textProcessor = new Dll.TextProcessor();

            var type = textProcessor.GetType();

            var methodInfo = type.GetMethod("Run", BindingFlags.NonPublic | BindingFlags.Instance);

            var result = (IEnumerable<string>)methodInfo!.Invoke(textProcessor, parameters: new object?[] { allText })!;

            File.WriteAllLines(resultFile, result);

        }
    }
}