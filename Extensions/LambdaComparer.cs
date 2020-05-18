using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FindAService_WebForm.Extensions
{
    public class LambdaComparer<T> : IEqualityComparer<T>
    {
        private readonly Func<T, T, bool> _expression;

        public LambdaComparer(Func<T, T, bool> lambda)
        {
            _expression = lambda;
        }

        bool IEqualityComparer<T>.Equals(T x, T y)
        {
            return _expression(x, y);
        }

        int IEqualityComparer<T>.GetHashCode(T obj)
        {
            return 0;
        }
    }
}
