const versionCache = "chache-v1";
const assets = [
  "/",
  "/index.html",
  "/icon512_maskable.png",
  "/icon512_rounded.png",
];

self.addEventListener("install", (installEvent) => {
  installEvent.waitUntil(
    caches.open(versionCache).then((cache) => {
      cache.addAll(assets);
    })
  );
});

self.addEventListener("fetch", (fetchEvent) => {
  fetchEvent.respondWith(
    caches.match(fetchEvent.request).then((res) => {
      return res || fetch(fetchEvent.request);
    })
  );
});
