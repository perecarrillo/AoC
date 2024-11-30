#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <cstddef>
#include <omp.h>
#include <map>
#include <unordered_map>
#include <tuple>

std::string repeat(std::string str, const std::size_t n)
{
    if (n == 0)
    {
        str.clear();
        str.shrink_to_fit();
        return str;
    }
    else if (n == 1 || str.empty())
    {
        return str;
    }
    const auto period = str.size();
    if (period == 1)
    {
        str.append(n - 1, str.front());
        return str;
    }
    str.reserve(period * n);
    std::size_t m{2};
    for (; m < n; m *= 2)
        str += str;
    str.append(str.c_str(), (n - (m / 2)) * period);
    return str;
}

using namespace std;

// https://www.linkedin.com/pulse/generic-tuple-hashing-modern-c-alex-dathskovsky
// Hashing for tuples (and any type)
namespace std
{
    template <typename T, template <typename...> typename Template>
    struct IsSpecialization : std::false_type
    {
    };
    template <template <typename...> typename Template, typename... Args>
    struct IsSpecialization<Template<Args...>, Template> : std::true_type
    {
    };

    template <template <typename... Args> typename Container, typename... Args>
    struct hash<Container<Args...>> : public __hash_base<size_t, Container<Args...>>
    {
        size_t operator()(const Container<Args...> &container) const noexcept
        {
            size_t result = 0xEEDDFFCC;
            if constexpr (IsSpecialization<Container<Args...>, pair>::value)
            {
                result ^= hash<remove_cv_t<decltype(container.first)>>{}(container.first);
                result ^= hash<remove_cv_t<decltype(container.second)>>{}(container.second);
            }
            else if constexpr (IsSpecialization<Container<Args...>, tuple>::value)
            {
                apply([&result](auto... val)
                      { ((result ^= hash<remove_cv_t<decltype(val)>>{}(val)), ...); },
                      container);
            }
            else
            {
                for (auto item : container)
                {
                    result ^= (hash<decltype(item)>{}(item) << 8);
                }
            }
            return result;
        }
    };
}

// unordered_map<string, unsigned long long> DP;

// vector<int> nums;
// string springs;

// iChar and prevChar != '?'
unsigned long long processLine(unordered_map<tuple<int, int, int, char, char>, unsigned long long> &DP, const string &springs, const vector<int> &nums, int stringStart, int vectorStart, int initialSize, char iChar, char prevChar)
{
    if (auto it = DP.find({stringStart, vectorStart, initialSize, iChar, prevChar}); it != DP.end())
    {
        // cout<<"Using DP"<<endl;
        return it->second;
    }
    int size = initialSize;
    bool stop = false;
    int stopi;
    int i = stringStart;

    if (iChar == '#')
    {
        if (nums.size() <= vectorStart)
        {
            return 0;
        }
        ++size;
        if (size > nums[vectorStart])
        {
            return 0;
        }
    }
    else if (stringStart > 0 and prevChar == '#')
    {
        if (size != nums[vectorStart])
            return 0;
        size = 0;
        ++vectorStart;
    }
    prevChar = iChar;
    ++i;

    for (; not stop and i < springs.length(); ++i)
    {
        if (springs[i] == '#')
        {
            if (nums.size() <= vectorStart)
            {
                return 0;
            }
            ++size;
            if (size > nums[vectorStart])
            {
                return 0;
            }
            prevChar = '#';
        }
        else if (springs[i] == '.')
        {
            if (i <= 0)
                continue;
            if (prevChar == '#')
            {
                if (size != nums[vectorStart])
                    return 0;
                size = 0;
                ++vectorStart;
            }
            prevChar = '.';
        }
        else
        {
            stop = true;
            stopi = i;
        }
    }
    if (not stop)
    {
        if (vectorStart == nums.size() - 1 && size == nums[vectorStart])
            return 1;
        if (vectorStart != nums.size())
            return 0;
        return 1;
    }

    unsigned long long case1, case2;

    if (auto it = DP.find({stopi, vectorStart, size, '#', prevChar}); it != DP.end())
    {
        case1 = it->second;
        // cout<<"Using DP"<<endl;
    }
    else
    {
        case1 = processLine(DP, springs, nums, stopi, vectorStart, size, '#', prevChar);
        DP[{stopi, vectorStart, size, '#', prevChar}] = case1;
    }

    if (auto it = DP.find({stopi, vectorStart, size, '.', prevChar}); it != DP.end())
    {
        case2 = it->second;
        // cout<<"Using DP"<<endl;
    }
    else
    {
        case2 = processLine(DP, springs, nums, stopi, vectorStart, size, '.', prevChar);
        DP[{stopi, vectorStart, size, '.', prevChar}] = case2;
    }

    return case1 + case2;
}

int main()
{
    string line;
    getline(cin, line);
    vector<string> totalSprings;
    vector<vector<int>> totalNums;

    while (line != "DONE")
    {
        int pos = line.find(' ');
        string springs = line.substr(0, pos) + "?";
        string numsList = "," + line.substr(pos + 1, line.size());

        springs = "." + repeat(springs, 5);
        springs.pop_back();
        numsList = repeat(numsList, 5);

        istringstream is(numsList);
        int n;
        char foo;
        vector<int> nums;
        // nums.clear();
        while (is >> foo >> n)
        {
            nums.push_back(n);
        }

        totalSprings.push_back(springs);
        totalNums.push_back(nums);
        getline(cin, line);
    }

    unsigned long long sum = 0;

#pragma omp parallel for schedule(dynamic, 1) reduction(+ : sum)
    for (int i = 0; i < totalSprings.size(); ++i)
    {

        /*cout << "Springs: " << totalSprings[i] << endl;
        cout << "Nums: ";
        for (auto v : totalNums[i])
        {
            cout << v << ' ';
        }
        cout << endl;*/

        unordered_map<tuple<int, int, int, char, char>, unsigned long long> DP;

        unsigned long long a = processLine(DP, totalSprings[i], totalNums[i], 0, 0, 0, '.', '.');
        // printf("%d:%llu\n", i, a);
        // cout << i <<": "<< a << endl;
        sum += a;
    }
    cout << "Total sum: " << sum << endl;
}
