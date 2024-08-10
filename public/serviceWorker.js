const cacheName = "chache-v1";
const assets = [
  "https://lamdera.com/images/llama/floaty.png",
  "https://elm.land/images/logo-480.png",
  "/",
  "/lists",
];

self.addEventListener("install", (installEvent) => {
  installEvent.waitUntil(
    caches.open(cacheName).then((cache) => {
      cache.addAll(assets);
    })
  );
});

self.addEventListener("fetch", (event) => {
  // check if request is on my domain
  if (!event.request.url.startsWith(self.location.origin)) {
    return;
  }

  event.respondWith(
    caches.open(cacheName).then((cache) => {
      // Go to the cache first
      return cache.match(event.request.url).then((cachedResponse) => {
        // Return a cached response if we have one
        if (cachedResponse) {
          return cachedResponse;
        }

        // Otherwise, hit the network
        return fetch(event.request)
          .then((fetchedResponse) => {
            console.log(fetchedResponse.status);
            // Add the network response to the cache for later visits
            cache.put(event.request, fetchedResponse.clone());

            // Return the network response
            return fetchedResponse;
          })
          .catch((err) =>
            cache.match("/").then((chached) => {
              if (cached) return cached;
            })
          );
      });
    })
  );
});