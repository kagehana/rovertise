## Variables to Set
- `webhook`  | The webhook URL you want logs to be sent to.
- `msgdelay` | The delay between advertisements, and subsequently, the delay between orbits **(2.15 IS RECOMMENDED)**.
- `discord`  | The vanity to your server. Set this like "/<vanity>", such as "/hi"
- `codebase` | The link to your modified version of this. The **how & why** to this is somewhere below.
- `phrases`  | The phrases to be advertised with the vanity. The **how & why** to this is also below.


## How & Why
- `codebase`
Since you want the bot to execute the same code over and over as it rejoins new servers, you need to have a place for the code. The script will queue this code for execution upon teleporting. You can place it on **GitHub** and use a raw-content link, a raw **Pastebin** link, or just really anything with your raw, modified version of this code. An example would be: https://pastebin.com/raw/CwzKzpW4
- `phrases`
Fill this with a table of strings. Example:
```lua
local phrases = {
    'hi, join %s',
    'hot people in %s',
    'nitro giveaway %s'
}
```
Make sure to use **%s** in place of your server vanity. The script will automatically replace it when sending messages.

## Discussion
Yes, I'm aware this code isn't super advanced. It's simply experimental, and does the job. If you want more functionality, add it. I also posted this because people kept gate-keeping something so simple.

## Running It
Get on an account, run the script with all set variables, and let it go.
