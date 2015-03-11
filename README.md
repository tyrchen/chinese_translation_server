Chinese Translation Server
===========================

Simple service for chinese words translation (simplified <-> traditional), chinese words to pinyin, and chinese words to slug.

## How to use

### TCP server

Client can connect to port 4040, and send commands:

```
COMMAND args\r\n
```

Server will reply:

```
result\r\n
```

For example, if client sent the following command to server,

```
PINYIN 中国人\r\n
```

server will response:

```
zhōng guó rén\r\n
```

### HTTP server

TBD.

User could use this service with below endpoints:

```
GET /api/v1/trad/<param>
GET /api/v1/simp/<param>
GET /api/v1/pinyin/<param>
GET /api/v1/slug/<param>
GET /api/v1/slug1/<param>
```

## Why provide this service?

translation/pinyin/slug are common simple services for building chinese sites. Instead of build them from scratch with performance and other issues, using an existing fully distributed simple services makes more sense.

As chinese_translation module is done by Elixir (and extensively use elixir's potential), it is hard to be used by users with other languages. Building a simple service against it will help other language users adopt it.

translation between traditional chinese and simplified chinese is especially usefull if your users from both mainlain china and HK/Taiwan. Rather then char-by-char translation, this service will do word-by-word translation, which produces much better results.

slug is also useful to generate user friendly URLs. However, existing slugify modules are either with low performance or lack of capability to translate polyphone. This service will slugify based on words, not characters, with very high performance.

pinyin might not be so useful, I just provide it to see if anyone is acutally using it.

## License

    Copyright © 2015-2016 Tyr Chen <tchen@toureet.com>

    This work is free. You can redistribute it and/or modify it under the
    terms of the MIT License. See the LICENSE file for more details.
