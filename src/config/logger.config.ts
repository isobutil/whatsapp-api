/**
 * ┌──────────────────────────────────────────────────────────────────────────────┐
 * │ @author jrCleber                                                             │
 * │ @filename logger.config.ts                                                   │
 * │ Developed by: Cleber Wilson                                                  │
 * │ Creation date: Nov 27, 2022                                                  │
 * │ Contact: contato@codechat.dev                                                │
 * ├──────────────────────────────────────────────────────────────────────────────┤
 * │ @copyright © Cleber Wilson 2022. All rights reserved.                        │
 * │ Licensed under the Apache License, Version 2.0                               │
 * │                                                                              │
 * │  @license "https://github.com/code-chat-br/whatsapp-api/blob/main/LICENSE"   │
 * │                                                                              │
 * │ You may not use this file except in compliance with the License.             │
 * │ You may obtain a copy of the License at                                      │
 * │                                                                              │
 * │    http://www.apache.org/licenses/LICENSE-2.0                                │
 * │                                                                              │
 * │ Unless required by applicable law or agreed to in writing, software          │
 * │ distributed under the License is distributed on an "AS IS" BASIS,            │
 * │ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.     │
 * │                                                                              │
 * │ See the License for the specific language governing permissions and          │
 * │ limitations under the License.                                               │
 * │                                                                              │
 * │ @function formatDateLog @param {Number} timestamp                            │
 * │ @enum {Color} @enum {Command} @enum {Level} @enum {Type} @enum {Background}  │
 * │                                                                              │
 * │ @class                                                                       │
 * │ @constructs Logger @param {String} context                                   │
 * ├──────────────────────────────────────────────────────────────────────────────┤
 * │ @important                                                                   │
 * │ For any future changes to the code in this file, it is recommended to        │
 * │ contain, together with the modification, the information of the developer    │
 * │ who changed it and the date of modification.                                 │
 * └──────────────────────────────────────────────────────────────────────────────┘
 */

import { existsSync, mkdirSync } from 'fs';
import { join } from 'path';
import pino from 'pino';
import { ConfigService, Log } from './env.config';
import { ROOT_DIR } from './path.config';

const LOG_DIR = join(ROOT_DIR, 'logs');
if (!existsSync(LOG_DIR)) {
  mkdirSync(LOG_DIR, { recursive: true });
}

export class Logger {
  constructor(
    private readonly configService: ConfigService,
    private readonly context = 'Logger',
  ) {
    const level = configService.get<Log>('LOG').LEVEL;

    this.logger = pino({
      level,
      timestamp: pino.stdTimeFunctions.isoTime,
      // Write everything to stdout (human-readable) AND to a file on disk,
      // so `docker logs` shows the live flow while the file survives it.
      transport: {
        targets: [
          {
            target: 'pino-pretty',
            level,
            options: {
              destination: 1,
              colorize: configService.get<Log>('LOG').COLOR,
              translateTime: 'SYS:standard',
              levelFirst: true,
              singleLine: true,
              ignore: 'pid,hostname',
            },
          },
          {
            target: 'pino/file',
            level,
            options: { destination: join(LOG_DIR, 'app.log'), mkdir: true },
          },
        ],
      },
    });
  }

  private readonly logger: pino.Logger;

  setCtx(ctx: string) {
    return new Logger(this.configService, ctx);
  }

  get log() {
    return this.logger;
  }

  info(msg: string, props?: Record<string, any>) {
    this.logger.child({ context: this.context, ...props }).info(msg);
  }

  warn(msg: string, props?: Record<string, any>) {
    this.logger.child({ context: this.context, ...props }).warn(msg);
  }

  debug(msg: string, props?: Record<string, any>) {
    this.logger.child({ context: this.context, ...props }).debug(msg);
  }

  error(msg: string, props?: Record<string, any>) {
    this.logger.child({ context: this.context, ...props }).error(msg);
  }

  fatal(msg: string, props?: Record<string, any>) {
    this.logger.child({ context: this.context, ...props }).fatal(msg);
  }

  trace(msg: string, props?: Record<string, any>) {
    this.logger.child({ context: this.context, ...props }).trace(msg);
  }
}
