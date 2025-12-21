using System;
using System.Collections.Generic;
using System.Linq;

namespace Artimus.Extensions;

public static class EnumerableExtensions {
	public static readonly Random Random = new();

	public static T[] Append<T>(this IEnumerable<T> collection, T item) {
		return new List<T>(collection) { item }.ToArray();
	}

	public static T[] Append<T, TOrder>(this IEnumerable<T> collection, T item, Func<T, TOrder> orderBy) {
		return new List<T>(collection) { item }
			.OrderBy(orderBy)
			.ToArray();
	}

	public static T[] Shuffle<T>(this IEnumerable<T> collection) {
		var list = collection.ToList();
		var length = list.Count;

		for (var i = length - 1; i > 0; i--) {
			var index = Random.Next(i + 1);

			(list[i], list[index]) = (list[index], list[i]);
		}

		return list.ToArray();
	}
}