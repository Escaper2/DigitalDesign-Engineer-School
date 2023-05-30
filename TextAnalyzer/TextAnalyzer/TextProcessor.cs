using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;



namespace TextAnalyzer
{
    internal class TextProcessor
    {
        private const string FolderPath = "..\\..\\..\\..\\Resources\\";

        private string _path;

        public TextProcessor(string name)
        {
            if (name is null) throw new ArgumentNullException();

            _path = Path.Combine(FolderPath, name + ".txt");


            if (!File.Exists(_path))
            {
                Console.WriteLine("Place your file in the resources folder");
            }
        }


        public void Run()
        {
            var allText = File.ReadAllText(_path, Encoding.GetEncoding(1251));

            var resultFile = Path.Combine(FolderPath, "Result.txt");

            string[] splitWords = new Regex("[^a-zA-Zа-яА-Я]|\\b[a-zA-Zа-яА-Яё]{1,3}\\b").Replace(allText, " ").ToLower().Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);

            var uniqueWords = splitWords.GroupBy(x => x).OrderByDescending(x => x.Count());


            File.WriteAllLines(resultFile, uniqueWords.Select(gr => $"{gr.Key} {gr.Count()}"));

        }

    }
}