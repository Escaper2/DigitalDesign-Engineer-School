using System.Diagnostics;
using System.Reflection;
using System.Text;
using Dll;

namespace SecondTask
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

            var stopwatch = new Stopwatch();
            var stopwatch2 = new Stopwatch();


            var textProcessor = new Dll.TextProcessor();

            var type = textProcessor.GetType();

            var methodInfo = type.GetMethod("Run", BindingFlags.NonPublic | BindingFlags.Instance);


            //Time measurement

            stopwatch.Start();

            var result = (IEnumerable<string>)methodInfo!.Invoke(textProcessor, parameters: new object?[] { allText })!;

            stopwatch.Stop();

            stopwatch2.Start();

            textProcessor.RunParallel(allText);

            stopwatch2.Stop();


            Console.WriteLine($"Default method execution time: {stopwatch.ElapsedMilliseconds } milliseconds");
            Console.WriteLine($"Parallel method execution time: {stopwatch2.ElapsedMilliseconds } milliseconds");


            File.WriteAllLines(resultFile, result);

        }
    }
}