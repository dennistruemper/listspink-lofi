const cacheName = "chache-v1";
const assets = [
  "https://lamdera.com/images/llama/floaty.png",
  "https://elm.land/images/logo-480.png",
  "/",
  "/lists",
];
/*
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
            cache.match("/").then((cached) => {
              if (cached) return cached;
            })
          );
      });
    })
  );
});
*/

importScripts(
  "https://storage.googleapis.com/workbox-cdn/releases/6.5.4/workbox-sw.js"
);

// This is your Service Worker, you can put any of your custom Service Worker
// code in this file, above the `precacheAndRoute` line.

// When widget is installed/pinned, push initial state.
self.addEventListener("widgetinstall", (event) => {
  event.waitUntil(updateWidget(event));
});

// When widget is shown, update content to ensure it is up-to-date.
self.addEventListener("widgetresume", (event) => {
  event.waitUntil(updateWidget(event));
});

// When the user clicks an element with an associated Action.Execute,
// handle according to the 'verb' in event.action.
self.addEventListener("widgetclick", (event) => {
  if (event.action == "updateName") {
    event.waitUntil(updateName(event));
  }
});

// When the widget is uninstalled/unpinned, clean up any unnecessary
// periodic sync or widget-related state.
self.addEventListener("widgetuninstall", (event) => {});

const updateWidget = async (event) => {
  // The widget definition represents the fields specified in the manifest.
  const widgetDefinition = event.widget.definition;

  // Fetch the template and data defined in the manifest to generate the payload.
  const payload = {
    template: JSON.stringify(
      await (await fetch(widgetDefinition.msAcTemplate)).json()
    ),
    data: JSON.stringify(await (await fetch(widgetDefinition.data)).json()),
  };

  // Push payload to widget.
  await self.widgets.updateByInstanceId(event.instanceId, payload);
};

const updateName = async (event) => {
  const name = event.data.json().name;

  // The widget definition represents the fields specified in the manifest.
  const widgetDefinition = event.widget.definition;

  // Fetch the template and data defined in the manifest to generate the payload.
  const payload = {
    template: JSON.stringify(
      await (await fetch(widgetDefinition.msAcTemplate)).json()
    ),
    data: JSON.stringify({ name }),
  };

  // Push payload to widget.
  await self.widgets.updateByInstanceId(event.instanceId, payload);
};

workbox.precaching.precacheAndRoute(self.__WB_MANIFEST || []);
