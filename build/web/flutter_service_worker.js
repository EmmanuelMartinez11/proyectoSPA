'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "d848fa3235ec444e0fba8d5c82991f34",
"assets/AssetManifest.bin.json": "40ba1a6374e835d5004d232867e57013",
"assets/AssetManifest.json": "707f4498b10ed895b5c876542bb1e60c",
"assets/assets/images/alimentos.png": "289c5249018651468153dddb4a17eacb",
"assets/assets/images/Anti-stress.jpg": "280eddf61a5f570b2d0b20415f474b17",
"assets/assets/images/back.png": "35e09b1ef70bb86c1b50b34fc88f62e5",
"assets/assets/images/background.jpg": "be6e9b0bfae882094791fd400a45fef8",
"assets/assets/images/background.png": "010a09107c0f4f3f97662bba86bb47dd",
"assets/assets/images/backgroundNoticia.png": "033208313c91a922ca26469652250081",
"assets/assets/images/backgroundService.png": "2132ea91c6316035d49ebccfac7a1bdd",
"assets/assets/images/Belleza-Manos-Pies.jpg": "274e07df31a02952a62c7bf3d01f0190",
"assets/assets/images/belleza.webp": "ef512b1170ea0bb09574259f9302bb9d",
"assets/assets/images/blog.webp": "d197fb99bdb5e56dcf56114e185297ea",
"assets/assets/images/chill.png": "59e4d5fa30fcb372292a69cf11a95157",
"assets/assets/images/corporales.webp": "a01364bfc5e82f34e01238be79155966",
"assets/assets/images/Crio-Frecuencia-Corporal.jpg": "3ad3828cea80892c927c8049637475a5",
"assets/assets/images/Crio-Frecuencia-Facial.jpg": "11b1edd42469a121df582afc8ce472f6",
"assets/assets/images/Depilacion-Facial.jpg": "0274d0f558a641a009527336abdd1965",
"assets/assets/images/DermoHealth.jpg": "9bb322a3c2991bbd96de87d2a20ad7bb",
"assets/assets/images/design.png": "8dcefd2f7fb83a4623b34bef74c699f9",
"assets/assets/images/facial.png": "7e54f192a3ecc91059d2fdd6266b97de",
"assets/assets/images/Facial.webp": "b9d8f9f405c0e6b6b4fe1f9b51082cfc",
"assets/assets/images/ingresar.jpg": "1df7aba004f5a6a9ea82be36588b225a",
"assets/assets/images/ingresar.webp": "b82bc369dc61653455b1e1445d558497",
"assets/assets/images/Lifting-Pestanas.jpg": "af67a579a4b65a3c7d2cf4a815bf7826",
"assets/assets/images/Limpieza-Profunda-Hidratacion.jpg": "e76404a8e15e6b5a624d1fe1dfa02f4e",
"assets/assets/images/logo_spa.png": "0e23c81d4564b8134a54dc748d594728",
"assets/assets/images/Masaje-Circulatorio.jpg": "5553efd207e38ca724c7b64bf28892e7",
"assets/assets/images/Masaje-Descontracturante.jpg": "ccbdeb77758ebdb18d9e74d9da25c796",
"assets/assets/images/Masaje-Piedras-Calientes.jpg": "24e05c4c1c56be68b438fd128350cce5",
"assets/assets/images/masajeN.png": "6c82d5b50f7f56830c05642c118b7e9f",
"assets/assets/images/masajes.jpg": "5c16e45020994820338b62bcb24b9147",
"assets/assets/images/masajes.webp": "fd1726072b6ed48837cd1271d4de839c",
"assets/assets/images/masajesRelajantes.webp": "5c16e45020994820338b62bcb24b9147",
"assets/assets/images/massage.png": "6098bf24b9adb2f9cc61ecad0d2f6ebd",
"assets/assets/images/meditacion.png": "373f739d7446888becb05407f10a162f",
"assets/assets/images/noticia1.png": "67f22ba983a49d318b0c72b9058730be",
"assets/assets/images/Punta-Diamante.jpg": "6ac46925fe054cc3fcbb3cdf905b1859",
"assets/assets/images/spa1.webp": "2b58eb11c79ad3ae027ca62ed3ee32fb",
"assets/assets/images/spa2.webp": "1975038822f5ff5927956356552ee801",
"assets/assets/images/spa3.webp": "babde2be3e17fde5d6196a54756233bf",
"assets/assets/images/tratamiento-facial.jpg": "8ad13fd8574d25d9486700839e731a55",
"assets/assets/images/Tratamiento-facial2.jpg": "0ff034b7f0f3e21e19670682b50bb1f0",
"assets/assets/images/tratamientos-Corporales.jpg": "a08914a57178f7f63bfe40cc6e3c9a40",
"assets/assets/images/Ultracavitacion.jpg": "69808c098b4ac003f63f57a422eed3dd",
"assets/assets/images/VelaSlim.jpg": "456b49157925544cf35d07a5adbb9887",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/fonts/MaterialIcons-Regular.otf": "aa6f96b43e278d8854cc6c6539d82f47",
"assets/NOTICES": "4e4ecb74175ea2a5033c1b559365b777",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "b816a2f7745b89d1b9f0b3fb805995c2",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "b70ccf6f1e4435bd08808199af3f7fa2",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "04f83c01dded195a11d21c2edf643455",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "9fc2555b74061f2f6f67cce5b43325dd",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "7b349f39a855a3c629c1b6d4f0381961",
"/": "7b349f39a855a3c629c1b6d4f0381961",
"main.dart.js": "8331846da338971de41803e6b815458d",
"manifest.json": "bada3d470faa885025133d17e3c42101",
"version.json": "3ba2e1d1494b2a1efcbf71849b1d9144"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
